import 'dart:math';
import 'dart:ui';
import 'package:Hogwarts/pages/userInfo.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:Hogwarts/component/UserAdminItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Hogwarts/utils/config.dart';

//TODO 搜索、分类与过滤同时应用未实现，同一时刻只有最后的操作生效
//TODO 移动端UI适配问题，stack覆盖和标签过长overflow
//TODO 列表为空时展示一个图片
class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Choice _selectedChoice = choices[0]; // The app's "state".
  int lanIndex = GlobalSetting.globalSetting.lanIndex;

  void _select(Choice choice) {
    setState(() {
      // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      choices[0] = new Choice(
          title: lanIndex == 0 ? '景点管理' : 'SpotAdmin', icon: Icons.desktop_mac);
      choices[1] = new Choice(
          title: lanIndex == 0 ? '用户管理' : 'UserAdmin', icon: Icons.group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          lanIndex == 0 ? '系统管理' : 'Admin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            // overflow menu
            icon: Icon(Icons.dashboard),
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map<PopupMenuItem<Choice>>((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: new ListTile(
                    leading: Icon(choice.icon),
                    title: Text(choice.title),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ChoiceCard(choice: _selectedChoice),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

List<Choice> choices = <Choice>[
  Choice(title: '景点管理', icon: Icons.desktop_mac),
  Choice(title: '用户管理', icon: Icons.group),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    if (choice.title == '景点管理'||choice.title =='SpotAdmin')
      return UserAdmin();
    else if (choice.title == '用户管理'||choice.title =='UserAdmin')
      return UserAdmin();
    else
      return UserAdmin();
  }
}

//class ProjectAdmin extends StatefulWidget {
//  @override
//  _ProjectAdminState createState() => _ProjectAdminState();
//}
//
//class _ProjectAdminState extends State<ProjectAdmin> with TickerProviderStateMixin {
//  AnimationController animationController;
//
//  List<Job> originJobList = [];
//  List<Job> jobList = [];
//  String searchCondition;
//  String chooseJobState = "待审阅";
//
//  final ScrollController _scrollController = ScrollController();
//  final width = window.physicalSize.width;
//
//  @override
//  void initState() {
//    animationController = AnimationController(
//        duration: const Duration(milliseconds: 1000), vsync: this);
//    super.initState();
//    getJobs();
//  }
//
////  //假数据随机数
////  int getState() {
////    return new Random().nextInt(6) - 3;
////  }
////  int getMaxPriceRandom() {
////    return (new Random().nextInt(10) + 1) * 10;
////  }
////  int getMinPriceRandom() {
////    return new Random().nextInt(10) + 1;
////  }
////  int getPriceTypeRandom() {
////    return new Random().nextInt(2);
////  }
//  String getPublishTime() {
//    return '2020-0' + (new Random().nextInt(9) + 1).toString() + '-' + (new Random().nextInt(20) + 10).toString();
//  }
//  String getDeadline() {
//    return '2020-0' + (new Random().nextInt(9) + 1).toString() + '-' + (new Random().nextInt(20) + 10).toString();
//  }
//
//  getJobs() async {
//    List<Job> jobs = [];
//    List<Job> chooseJobs = [];
//    var response = [];
//    String url = "${Url.url_prefix}/getJobs";
//    String token = await StorageUtil.getStringItem('token');
//    final res = await http.get(url, headers: {"Accept": "application/json","Authorization": "$token"});
//    final data = json.decode(res.body);
//    response = data;
//    for(int i = 0; i < response.length; ++i){
//      List<String> skills = [];
//      for(int j = 0; j < response[i]['skills'].length; ++j){
//        skills.add(response[i]['skills'][j].toString());
//      }
//      jobs.add(Job(response[i]['id'], response[i]['title'], response[i]['employerId'], response[i]['employerName'], response[i]['description'], skills, response[i]['type'], response[i]['low'], response[i]['high'], response[i]['state'], response[i]['publishTime'], response[i]['deadline']));
//    }
//    setState(() {
//      originJobList = jobs;
//    });
//    for(int i = 0; i < originJobList.length; ++i){
//      if(originJobList[i].state == -3) chooseJobs.add(originJobList[i]);
//    }
//    setState(() {
//      jobList = chooseJobs;
//    });
//  }
//
//  executeSearch() {
//    List<Job> jobs = [];
//    for(int i = 0; i < originJobList.length; ++i){
//      if(originJobList[i].projectName.contains(searchCondition)) jobs.add(originJobList[i]);
//    }
//    setState(() {
//      jobList = jobs;
//    });
//  }
//
//  @override
//  void dispose() {
//    animationController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        InkWell(
//          splashColor: Colors.transparent,
//          focusColor: Colors.transparent,
//          highlightColor: Colors.transparent,
//          hoverColor: Colors.transparent,
//          onTap: () {
//            FocusScope.of(context).requestFocus(FocusNode());
//          },
//          child: Column(
//            children: <Widget>[
//              Expanded(
//                child: NestedScrollView(
//                  controller: _scrollController,
//                  headerSliverBuilder:
//                      (BuildContext context, bool innerBoxIsScrolled) {
//                    return <Widget>[
//                      SliverList(
//                        delegate: SliverChildBuilderDelegate(
//                                (BuildContext context, int index) {
//                              return Column(
//                                children: <Widget>[
//                                  getSearchBarUI(),
//                                ],
//                              );
//                            }, childCount: 1),
//                      ),
//                      SliverPersistentHeader(
//                        pinned: true,
//                        delegate: ContestTabHeader(
//                          getFilterBarUI(),
//                        ),
//                      ),
//                    ];
//                  },
//                  body: Container(
//                    color:
//                    HotelAppTheme.buildLightTheme().backgroundColor,
//                    child: ListView.builder(
//                      itemCount: jobList.length,
//                      padding: const EdgeInsets.only(top: 8),
//                      scrollDirection: Axis.vertical,
//                      itemBuilder: (BuildContext context, int index) {
//                        final int count =
//                        jobList.length > 10 ? 10 : jobList.length;
//                        final Animation<double> animation =
//                        Tween<double>(begin: 0.0, end: 1.0).animate(
//                            CurvedAnimation(
//                                parent: animationController,
//                                curve: Interval(
//                                    (1 / count) * index, 1.0,
//                                    curve: Curves.fastOutSlowIn)));
//                        animationController.forward();
//                        return ProjectAdminItem(
//                          callback: () {
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(jobList[index].projectId)));
//                          },
//                          navigateToEmployer: () {
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoPage(userId: jobList[index].employerId)));
//                          },
//                          toggleCallback: (value) async {
//                            String url = "${Url.url_prefix}/setJobState?jobId=" + jobList[index].projectId.toString() + '&state=';
//                            String token = await StorageUtil.getStringItem('token');
//                            if(value == 1){
//                              http.post(url + "-1", headers: {"Accept": "application/json","Authorization": "$token"});
//                              setState(() {
//                                jobList[index].state = -1;
//                              });
//                            }
//                            else {
//                              http.post(url + "0", headers: {"Accept": "application/json","Authorization": "$token"});
//                              setState(() {
//                                jobList[index].state = 0;
//                              });
//                            }
//                          },
//                          jobData: jobList[index],
//                          animation: animation,
//                          animationController: animationController,
//                          isLarge: MediaQuery.of(context).size.width > 1080,
//                        );
//                      },
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  Widget getSearchBarUI() {
//    return Padding(
//      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
//      child: Row(
//        children: <Widget>[
//          Expanded(
//            child: Padding(
//              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//              child: Container(
//                decoration: BoxDecoration(
//                  color: const Color(0xFFFFFFFF),
//                  borderRadius: const BorderRadius.all(
//                    Radius.circular(38.0),
//                  ),
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                        color: Colors.grey.withOpacity(0.2),
//                        offset: const Offset(0, 2),
//                        blurRadius: 8.0),
//                  ],
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.only(
//                      left: 16, right: 16, top: 4, bottom: 4),
//                  child: TextField(
//                    onChanged: (String txt) {
//                      searchCondition = txt;
//                    },
//                    style: const TextStyle(
//                      fontSize: 18,
//                    ),
//                    cursorColor: HexColor('#54D3C2'),
//                    decoration: InputDecoration(
//                      border: InputBorder.none,
//                      hintText: 'Search',
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
//          Container(
//            decoration: BoxDecoration(
//              color: HexColor('#54D3C2'),
//              borderRadius: const BorderRadius.all(
//                Radius.circular(38.0),
//              ),
//              boxShadow: <BoxShadow>[
//                BoxShadow(
//                    color: Colors.grey.withOpacity(0.4),
//                    offset: const Offset(0, 2),
//                    blurRadius: 8.0),
//              ],
//            ),
//            child: Material(
//              color: Colors.transparent,
//              child: InkWell(
//                borderRadius: const BorderRadius.all(
//                  Radius.circular(32.0),
//                ),
//                onTap: () {
//                  FocusScope.of(context).requestFocus(FocusNode());
//                  executeSearch();
//                },
//                child: Padding(
//                  padding: const EdgeInsets.all(16.0),
//                  child: Icon(Icons.search,
//                      size: 20,
//                      color: const Color(0xFFFFFFFF)),
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  handleFilterCondition(FilterCondition condition) {
//    print(condition);
//    bool fixedPriceExist = condition.fixedPriceExist.isSelected;
//    bool hourlyPriceExist = condition.hourlyPriceExist.isSelected;
//    List<Job> jobs = [];
//    List<Job> timeSatisfyJobs = [];
//    List<Job> skillSatisfyJobs = [];
//    for(int i = 0; i < originJobList.length; ++i){
//      if(originJobList[i].priceType == 0){
//        if(fixedPriceExist && originJobList[i].maxPrice <= condition.fixedPrices.end && originJobList[i].minPrice >= condition.fixedPrices.start)
//          jobs.add(originJobList[i]);
//      }
//      else{
//        if(hourlyPriceExist && originJobList[i].maxPrice <= condition.hourlyPrices.end && originJobList[i].minPrice >= condition.hourlyPrices.start)
//          jobs.add(originJobList[i]);
//      }
//    }
//    if(!condition.ifLimitDeadline){
//      if(!condition.ifLimitSkills) {
//        setState(() {
//          jobList = jobs;
//        });
//      }
//      else{
//        for(int i = 0; i < jobs.length; ++i){
//          bool satisfy = false;
//          for(int j = 0; j < condition.requireSkills.length; ++j){
//            if(jobs[i].skills.contains(condition.requireSkills[j]))
//              satisfy = true;
//          }
//          if(satisfy) skillSatisfyJobs.add(jobs[i]);
//        }
//        setState(() {
//          jobList = skillSatisfyJobs;
//        });
//      }
//    }
//    else{
//      for(int i = 0; i < jobs.length; ++i){
//        DateTime jobDate = DateTime.parse(jobs[i].deadline.replaceAll('.', '-'));
//        if(jobDate.isAfter(condition.startDate) && jobDate.isBefore(condition.endDate))
//          timeSatisfyJobs.add(jobs[i]);
//      }
//      if(!condition.ifLimitSkills) {
//        setState(() {
//          jobList = timeSatisfyJobs;
//        });
//      }
//      else{
//        for(int i = 0; i < timeSatisfyJobs.length; ++i){
//          bool satisfy = false;
//          for(int j = 0; j < condition.requireSkills.length; ++j){
//            if(timeSatisfyJobs[i].skills.contains(condition.requireSkills[j]))
//              satisfy = true;
//          }
//          if(satisfy) skillSatisfyJobs.add(timeSatisfyJobs[i]);
//        }
//        setState(() {
//          jobList = skillSatisfyJobs;
//        });
//      }
//    }
//  }
//
//  Widget getFilterBarUI() {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//          top: 0,
//          left: 0,
//          right: 0,
//          child: Container(
//            height: 24,
//            decoration: BoxDecoration(
//              color: HotelAppTheme.buildLightTheme().backgroundColor,
//              boxShadow: <BoxShadow>[
//                BoxShadow(
//                    color: Colors.grey.withOpacity(0.2),
//                    offset: const Offset(0, -2),
//                    blurRadius: 8.0),
//              ],
//            ),
//          ),
//        ),
//        Container(
//          decoration: BoxDecoration(
//            color: HotelAppTheme.buildLightTheme().backgroundColor,
//            boxShadow: <BoxShadow>[
//              BoxShadow(
//                  color: Colors.grey.withOpacity(0.2),
//                  offset: const Offset(0, 2),
//                  blurRadius: 8.0),
//            ],
//          ),
//          child: Padding(
//            padding:
//            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(
//                      '${jobList.length} jobs found',
//                      style: TextStyle(
//                        fontWeight: FontWeight.w100,
//                        fontSize: 16,
//                      ),
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(right: 10),
//                  child: getDropDownMenu(),
//                ),
//                Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    focusColor: Colors.transparent,
//                    highlightColor: Colors.transparent,
//                    hoverColor: Colors.transparent,
//                    splashColor: Colors.grey.withOpacity(0.2),
//                    borderRadius: const BorderRadius.all(
//                      Radius.circular(4.0),
//                    ),
//                    onTap: () {
//                      FocusScope.of(context).requestFocus(FocusNode());
//                      Navigator.push<dynamic>(
//                        context,
//                        MaterialPageRoute<dynamic>(
//                            builder: (BuildContext context) => FiltersScreen(filterConditionChange: handleFilterCondition,),
//                            fullscreenDialog: true),
//                      );
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.only(left: 8),
//                      child: Row(
//                        children: <Widget>[
//                          Text(
//                            'Filter',
//                            style: TextStyle(
//                              fontWeight: FontWeight.w100,
//                              fontSize: 16,
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Icon(Icons.sort,
//                                color: HotelAppTheme.buildLightTheme()
//                                    .primaryColor),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ],
//    );
//  }
//
//  Widget getDropDownMenu() {
//    return DropdownButton<String>(
//      value: chooseJobState,
//      icon: Icon(Icons.arrow_drop_down, color: HexColor('#54D3C2'),),
//      iconSize: 24,
//      elevation: 16,
//      style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black),
//      underline: Container(
//        height: 1,
//        color: Colors.grey.withOpacity(0.6),
//      ),
//      onChanged: (String newValue) {
//        setState(() {
//          chooseJobState = newValue;
//        });
//        executeChooseJobState();
//      },
//      items: <String>['所有项目', '待审阅', '竞标中', '已过期', '禁用的', '关闭的', '进行中', '已完成']
//          .map<DropdownMenuItem<String>>((String value) {
//        return DropdownMenuItem<String>(
//          value: value,
//          child: Text(value),
//        );
//      }).toList(),
//    );
//  }
//
//  executeChooseJobState() {
//    List<Job> jobs = [];
//    int state;
//    bool judgeTime = false;
//    bool isBid = true;
//    switch(chooseJobState){
//      case '所有项目': {
//        setState(() {
//          jobList = originJobList;
//        });
//        return;
//      }
//      break;
//      case '待审阅': {
//        state = -3;
//      }
//      break;
//      case '关闭的': {
//        state = -2;
//      }
//      break;
//      case '禁用的': {
//        state = -1;
//      }
//      break;
//      case '竞标中': {
//        state = 0;
//        judgeTime = true;
//      }
//      break;
//      case '已过期': {
//        state = 0;
//        judgeTime = true;
//        isBid = false;
//      }
//      break;
//      case '进行中': {
//        state = 1;
//      }
//      break;
//      case '已完成': {
//        state = 2;
//      }
//      break;
//    }
//    for(int i = 0; i < originJobList.length; ++i){
//      if(originJobList[i].state == state) jobs.add(originJobList[i]);
//    }
//    if(judgeTime){
//      List<Job> timeSatisfyJobs = [];
//      var now = DateTime.now();
//      if(isBid){
//        for(int i = 0; i < jobs.length; ++i){
//          var then = DateTime.parse(jobs[i].deadline.replaceAll('.', '-'));
//          if(then.isAfter(now)) timeSatisfyJobs.add(jobs[i]);
//        }
//      }
//      else{
//        for(int i = 0; i < jobs.length; ++i){
//          var then = DateTime.parse(jobs[i].deadline.replaceAll('.', '-'));
//          if(then.isBefore(now)) timeSatisfyJobs.add(jobs[i]);
//        }
//      }
//      setState(() {
//        jobList = timeSatisfyJobs;
//      });
//    }
//    else setState(() {
//      jobList = jobs;
//    });
//  }
//}

class UserAdmin extends StatefulWidget {
  UserAdmin({Key key}) : super(key: key);

  @override
  _UserAdminState createState() => new _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> with TickerProviderStateMixin {
  AnimationController animationController;
  int lanIndex= GlobalSetting.globalSetting.lanIndex;
  List<User> originUserList = [];
  List<User> userList = [];
  String searchCondition;
  String chooseUserRole = '所有用户';

  final ScrollController _scrollController = ScrollController();
  final width = window.physicalSize.width;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    setState(() {
      chooseUserRole = (lanIndex==0?'所有用户':'AllUser');
    });
    getUsers();
  }

//  /*得到随机数*/
//  int getRandom() {
//    return new Random().nextInt(4) - 2;
//  }

  getUsers() async {
    List<User> users = [];
    var response = [];
    String url = "${Url.url_prefix}/getUsers";
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url,
        headers: {"Accept": "application/json", "Authorization": "$token"});
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    response = data;
    for (int i = 0; i < response.length; ++i) {
      users.add(User(
          response[i]['id'],
          response[i]['name'],
          response[i]['gender'],
          response[i]['phone'],
          response[i]['description'],
          response[i]['role'],
          response[i]['icon']));
    }
    print(users.length);
    setState(() {
      originUserList = users;
      userList = users;
    });
  }

  executeSearch() {
    List<User> users = [];
    for (int i = 0; i < originUserList.length; ++i) {
      if (originUserList[i].name.contains(searchCondition))
        users.add(originUserList[i]);
    }
    setState(() {
      userList = users;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              getSearchBarUI(),
                            ],
                          );
                        }, childCount: 1),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: ContestTabHeader(
                          getFilterBarUI(),
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    color: HotelAppTheme.buildLightTheme().backgroundColor,
                    child: ListView.builder(
                      itemCount: userList.length,
                      padding: const EdgeInsets.only(top: 8),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final int count =
                            userList.length > 10 ? 10 : userList.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                        animationController.forward();
                        return UserAdminItem(
                          callback: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInfoPage(
                                        userId: userList[index].userId)));
                          },
                          toggleCallback: (value) async {
                            String url =
                                "${Url.url_prefix}/setUserRole?userId=" +
                                    userList[index].userId.toString() +
                                    '&role=';
                            String token =
                                await StorageUtil.getStringItem('token');
                            if (value == 1) {
                              http.get(url + "-1", headers: {
                                "Accept": "application/json",
                                "Authorization": "$token"
                              });
                              setState(() {
                                userList[index].role = -1;
                              });
                            } else {
                              http.get(url + "0", headers: {
                                "Accept": "application/json",
                                "Authorization": "$token"
                              });
                              setState(() {
                                userList[index].role = 0;
                              });
                            }
                          },
                          userData: userList[index],
                          animation: animation,
                          animationController: animationController,
                          isLarge: MediaQuery.of(context).size.width > 1080,
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      searchCondition = txt;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HexColor('#54D3C2'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: lanIndex==0?'搜索':'Search',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HexColor('#54D3C2'),
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  executeSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 20, color: const Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: HotelAppTheme.buildLightTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      lanIndex==0?'找到${userList.length}个用户': '${userList.length} users found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: getDropDownMenu(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getDropDownMenu() {
    return DropdownButton<String>(
      value: chooseUserRole,
      icon: Icon(
        Icons.arrow_drop_down,
        color: HexColor('#54D3C2'),
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.6),
      ),
      onChanged: (String newValue) {
        setState(() {
          chooseUserRole = newValue;
        });
        executeChooseUserRole();
      },
      items: (lanIndex==0?<String>['所有用户', '待核验', '已核验', '已封禁', '管理员']:<String>['AllUser', 'ToVerify', 'Verified', 'Banned', 'Admin'])
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  executeChooseUserRole() {
    List<User> users = [];
    int role;
    switch (chooseUserRole) {
      case '所有用户':case 'AllUser':
        {
          setState(() {
            userList = originUserList;
          });
          return;
        }
        break;
      case '待核验':case 'ToVerify':
        {
          role = -2;
        }
        break;
      case '已封禁':case 'Banned':
        {
          role = -1;
        }
        break;
      case '已核验':case 'Verified':
        {
          role = 0;
        }
        break;
      case '管理员':case 'Admin':
        {
          role = 1;
        }
        break;
    }
    for (int i = 0; i < originUserList.length; ++i) {
      if (originUserList[i].role == role) users.add(originUserList[i]);
    }
    setState(() {
      userList = users;
    });
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );

  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
