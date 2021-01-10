import 'dart:convert';
import 'dart:ui';
import 'package:Hogwarts/pages/userInfo.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/utils//config.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:http/http.dart' as http;
import 'UserAdminItem.dart';
import 'UserApplyItem.dart';

class ApplyModal extends StatefulWidget {
  const ApplyModal({
    Key key,
    this.apply,
    this.onCancelClick,
  }) : super(key: key);

  final List<int> apply;

  final Function onCancelClick;
  @override
  _ApplyModalState createState() => _ApplyModalState();
}

class _ApplyModalState extends State<ApplyModal> with TickerProviderStateMixin {
  AnimationController animationController;
  final ValueNotifier<bool> switchState = new ValueNotifier<bool>(true);

  bool ifImageChanged = false;
  List<User> userList = [];

  getUsers() async {
    print("start apply");
    List<User> users = [];
    String url;
    int i = 0;
    while (i < widget.apply.length) {
      print("222");
      url = "${Url.url_prefix}/getUser?id=" + widget.apply[i].toString();
      String token = await StorageUtil.getStringItem('token');
      final res = await http.get(url,
          headers: {"Accept": "application/json", "Authorization": "$token"});
      var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
      users.add(User(data['id'], data['name'], data['gender'], data['phone'],
          data['description'], data['role'], data['icon']));
      i = i + 1;
    }
    print("bababa");
    print(users.length);
    setState(() {
      userList = users;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController.forward();
    super.initState();
    getUsers();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: animationController.value,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: SizedBox(
                    width: 340,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.6),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24.0),
                                      topRight: Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Text(
                                        '好友申请',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: userList.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = userList.length > 10
                                        ? 10
                                        : userList.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController.forward();
                                    return UserApplyItem(
                                      callback: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserInfoPage(
                                                        userId: userList[index]
                                                            .userId)));
                                      },
                                      toggleCallback: (value) async {
                                        String url = "${Url.url_prefix}/";
                                        String token =
                                            await StorageUtil.getStringItem('token');
                                        int userID = await StorageUtil.getIntItem('uid');
                                        if (value == 0) {
                                          http.post(url + "addFriend?userId=" + userID.toString() + "&friendId=" + userList[index].userId.toString(), headers: {
                                            "Accept": "application/json",
                                            "Authorization": "$token"
                                          });
                                          setState(() {
                                            userList.removeAt(index);
                                          });
                                        } else {
                                          http.post(url + "rejectFriend?userId=" + userID.toString() + "&friendId=" + userList[index].userId.toString(), headers: {
                                            "Accept": "application/json",
                                            "Authorization": "$token"
                                          });
                                          setState(() {
                                            userList.removeAt(index);
                                          });
                                        }
                                      },
                                      userData: userList[index],
                                      animation: animation,
                                      animationController: animationController,
                                      isLarge:
                                          MediaQuery.of(context).size.width >
                                              1080,
                                    );
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
