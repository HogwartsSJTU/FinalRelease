import 'package:Hogwarts/pages/profile.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/PersonRateJobItem.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:Hogwarts/utils/config.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:Hogwarts/pages/diary.dart';

//'个人资料'、'我的资料'统一入口
class UserInfoPage extends StatefulWidget {
  UserInfoPage({this.userId});
  final int userId;

  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isOneSelf = false;

  @override
  void initState() {
    super.initState();
    getUserIdentity();
  }

  getUserIdentity() async {
    int userId = await StorageUtil.getIntItem("uid");
    setState(() {
      isOneSelf = (userId == widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isOneSelf)
      return Profile(userId: widget.userId);
    else
      return Person(
        userId: widget.userId,
      );
  }
}

class Person extends StatefulWidget {
  Person({this.userId});

  final int userId;

  @override
  State<StatefulWidget> createState() {
    return new _PersonState();
  }
}

class _PersonState extends State<Person> with TickerProviderStateMixin {
  TabController _tabController;
  int lanIndex = GlobalSetting.globalSetting.lanIndex;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "游记"),
  ];
  AnimationController animationController;
  FlutterToast flutterToast;
  bool alreadyFriend = false;

  User user = User(0, '', 0, '', '', '', '', true);
  List<Diary> diaryList = [];
  String _image =
      'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png';

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: tabs.length, vsync: this);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    flutterToast = FlutterToast(context);
    tabs[0] = new Tab(text: lanIndex == 0 ? "游记" : "TravelNotes");
    getUser();
    getDiary();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  getUser() async {
    User u;
    String url = "${Url.url_prefix}/getUser?id=" + widget.userId.toString();
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url,
        headers: {"Accept": "application/json", "Authorization": "$token"});
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    List<int> friends = [];
    for (int j = 0; j < data['friends'].length; ++j) {
      friends.add(data['friends'][j]);
    }
    int uid = await StorageUtil.getIntItem("uid");
    u = new User(
        data['id'],
        data['name'],
        data['age'],
        data['gender'],
        data['address'],
        data['phone'],
        data['description'],
        (data['isShow'] == 0) ? false : true);
    setState(() {
      user = u;
    });
    if (friends.contains(uid)) {
      setState(() {
        alreadyFriend = true;
      });
    }
    _image = data['icon'];
  }

  getDiary() async {
    List<Diary> diary = [];
    var response = [];
    String url =
        '${Url.url_prefix}/displayDiary?uid=' + widget.userId.toString();
    print("获得项目  " + widget.userId.toString());
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url,
        headers: {"Accept": "application/json", "Authorization": "$token"});
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    response = data;
    for (int i = 0; i < response.length; ++i) {
        List<String> pictures = [];
        for (int j = 0; j < response[i]['images'].length; ++j) {
          pictures.add(response[i]['images'][j].toString());
        }
        diary.add(Diary(
            response[i]['id'],
            response[i]['uid'],
            response[i]['text'],
            pictures,
            response[i]['date'],
        ));
    }
    setState(() {
      diaryList = diary;
    });
  }

  Widget diaList(List<Diary> jobList) {
    if (!user.recordCanSee) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_off,
              size: 50,
            ),
            Text(
              lanIndex == 0 ?"已设置查阅权限":'Query permission set',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
              child: Container(),
            )
          ],
        ),
      );
    } else if (jobList.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/empty.png'),
              height: 50,
              width: 50,
            ),
            Text(
              lanIndex == 0 ? "暂无游记发布":'No record of travel note',

              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
              child: Container(),
            )
          ],
        ),
      );
    } else
      return ListView.builder(
        itemCount: jobList.length,
        padding: const EdgeInsets.only(top: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final int count = jobList.length > 10 ? 10 : jobList.length;
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return PersonRateJobItem(
            callback: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DiaryScreen(diary: jobList[index], isEdit: false,)));
            },
            jobData: jobList[index],
            watcher: widget.userId,
            animation: animation,
            animationController: animationController,
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        // 头部信息栏
        SliverAppBar(
            leading: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            title: new Text(lanIndex == 0 ?"个人资料":'Personal Information', style: new TextStyle(color: Colors.white)),
            actions: <Widget>[
              !alreadyFriend
                  ? new IconButton(
                      icon: new Icon(Icons.add_circle),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(lanIndex == 0 ?'申请添加朋友':'Apply to add friends'),
                                  content: Text(lanIndex == 0 ?'确定向对方发送好友请求？':'Are you sure to send friend request to the other party?'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text(lanIndex == 0 ?"取消":'Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text(lanIndex == 0 ?"确定":'OK'),
                                      onPressed: () async {
                                        String url = "${Url.url_prefix}/";
                                        String token =
                                            await StorageUtil.getStringItem(
                                                'token');
                                        int userID =
                                            await StorageUtil.getIntItem('uid');
                                        http.post(
                                            url +
                                                "applyFriend?userId=" +
                                                userID.toString() +
                                                "&friendId=" +
                                                widget.userId.toString(),
                                            headers: {
                                              "Accept": "application/json",
                                              "Authorization": "$token"
                                            });
                                        _showToast();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      })
                  : new IconButton(
                      icon: Icon(Icons.group),
                      onPressed: () {},
                    )
            ],
            backgroundColor: Colors.blue,
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: new FlexibleSpaceBar(
                background: new Container(
                    width: MediaQuery.of(context).size.width,
                    padding: new EdgeInsets.all(16.0),
                    height: 200,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_image),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.grey.withOpacity(0.7),
                                BlendMode.darken))),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                              width: 95,
                              height: 95,
                              child: new CircleAvatar(
                                backgroundImage: NetworkImage(_image),
                              )),
                          new Expanded(
                              child: Container(
                                  height: 95,
                                  padding: new EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(user.name,
                                            style: new TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        new Row(children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0, vertical: 2.0),
                                            margin: const EdgeInsets.only(
                                                right: 15, top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            child: Text(
                                              user.age.toString() + (lanIndex == 0 ?'岁':''),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0, vertical: 2.0),
                                            margin: const EdgeInsets.only(
                                                right: 15, top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            child: Text(
                                              user.gender == 'M' ? (lanIndex == 0 ?'男':'M' ):( lanIndex == 0 ?'女':'F'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ])
                                      ])))
                        ])))),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              child: Container(
                color: HotelAppTheme.buildLightTheme().backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, bottom: 4),
                      child: Text(
                        lanIndex == 0 ?'资料卡':'Card',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              user.phone,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              user.address,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.border_color, color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 2),
                            child: Text(
                              user.description,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                color: HotelAppTheme.buildLightTheme().backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16, left: 16, bottom: 4, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              lanIndex == 0 ?'游记展板':'Travels',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ),
                          TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: new BubbleTabIndicator(
                              indicatorHeight: 25.0,
                              indicatorColor: Colors.blueAccent,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                            tabs: tabs,
                            controller: _tabController,
                          ),
                          SizedBox(
                            width: 100,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: user.recordCanSee ? 600 : 160,
                      child: TabBarView(
                        controller: _tabController,
                        children: tabs.map((Tab tab) {
                          return diaList(diaryList);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            lanIndex == 0 ?"成功发送好友请求":'Friend request sent successfully',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
