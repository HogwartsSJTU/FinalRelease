import 'dart:async';
import 'dart:convert';

import 'package:Hogwarts/component/friendApplyModal.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:Hogwarts/utils/multi_select_item.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/chat/favorite_contacts.dart';
import 'package:Hogwarts/component/chat/recent_chats.dart';
import 'package:Hogwarts/component/dialog/multi_select_dialog_field.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:Hogwarts/pages/profile.dart';
import 'package:Hogwarts/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:Hogwarts/utils/StorageUtil.dart';

class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  int lanIndex = GlobalSetting.globalSetting.lanIndex;

  //team
  int teamId = 0;

  //team invites
  List<TeamInvite> teamInviteList = [];
  List<UserBasic> userBasicList = [];
  List<int> idList = [];
  List<Position> positionList = [];

  //friends

  Timer _countdownTimer;
//  var _countdownNum = 0;
    void getPosition(){
      setState(() {
        if (_countdownTimer != null) {
          return;
        }
        _countdownTimer =
        new Timer.periodic(new Duration(seconds: 1), (timer){
//        setState(() {
//          _countdownNum ++;
//        });
          getUser();
        });
      });

    /*const timeout = const Duration(seconds: 1);
  Timer.periodic(timeout, (timer) { //callback function
  //1s 回调一次
  print('afterTimer='+DateTime.now().toString());

  timer.cancel();  // 取消定时器*/
  }

  @override
  void initState() {
    _selectedAnimals5 = _animals;
    super.initState();
    getUser();
    getPosition();
  }

  @override
  void dispose() {
    _selectedAnimals.length = 0;
    super.dispose();
    _countdownTimer?.cancel();
  }

  getUser() async {
    int uid = await StorageUtil.getIntItem('uid');
    String url = "${Url.url_prefix}/getUser?id=" + uid.toString();

    String token = await StorageUtil.getStringItem('token');

    print(token);
    final res = await http.get(url, headers: {"Authorization": "$token"});

//    final data = json.decode(res.body); //中文乱码
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    print(data);
    List<TeamInvite> teamInvite = [];
    for (int j = 0; j < data['teamInvites'].length; ++j) {
      TeamInvite ti = new TeamInvite(
          uid: data['teamInvites'][j]['uid'],
          tid: data['teamInvites'][j]['tid']);
      teamInvite.add(ti);
    }
    print(teamInvite);
    setState(() {
      teamId = data['teamId'];
      teamInviteList = teamInvite;
    });
    if (teamId != 0) getTeam();
  }

  getTeam() async {
    String url = "${Url.url_prefix}/getTeam?tid=" + teamId.toString();
    final res = await http.get(url);
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    List<UserBasic> uss = [];
    List<int> ids = [];
    List<Position> positions = [];
    for (int j = 0; j < data['num']; ++j) {
      int id = data['people'][j];
      ids.add(id);
      positions.add(new Position(
          x: data['position'][j]['x'], y: data['position'][j]['y']));
      UserBasic ub = await getUserBasic(id);
      uss.add(ub);
    }
    setState(() {
      userBasicList = uss;
      idList = ids;
      positionList = positions;
    });
  }

  Future<UserBasic> getUserBasic(int uid) async {
    String url = "${Url.url_prefix}/getUser?id=" + uid.toString();
    final res = await http.get(url);
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    return new UserBasic(name: data['name'], url: data['icon']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
          lanIndex == 0 ? '聊天' : 'Chat',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: SlidingUpPanel(
        renderPanelSheet: false,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
        body: Column(
          children: <Widget>[
//          CategorySelector(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Color(0xef83d3ea),//Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
//                    MultiSelectDialogField(
//                      items: _items,
//                      title: Text(lanIndex == 0 ? "好友列表" : 'Contacts'),
//                      selectedColor: Color(0xef83d3ea),
//                      // Colors.blue,
//                      decoration: BoxDecoration(
//                        color: Colors.blue.withOpacity(0.1),
//                        borderRadius: BorderRadius.all(Radius.circular(40)),
//                        border: Border.all(
//                          color: Colors.blue,
//                          width: 2,
//                        ),
//                      ),
//                      buttonIcon: Icon(
//                        Icons.people,
//                        color: Colors.blue,
//                      ),
//                      buttonText: Text(
//                        lanIndex == 0 ? " 邀请好友组队" : ' Invite your Friends',
//                        style: TextStyle(
//                          color: Colors.blue[800],
//                          fontSize: 16,
//                        ),
//                      ),
//                      onConfirm: (results) {
//                        setState(() {
//                          _selectedAnimals = results;
//                        });
//                      },
//                    ),
//                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
////                        SizedBox(height: 1),
//                      _selectedAnimals.length == 0
//                          ? SizedBox(
//                              height: 1,
//                            )
//                          : TextButton(
////                            icon: Icon(Icons.check),
////                            iconSize: 30.0,
////                            color: Color(0xef83d3ea), //Colors.blue,
//                              child: Text(
//                                lanIndex == 0 ? '确认组队' : 'Note',
//                                textAlign: TextAlign.left,
//                                style: TextStyle(
//                                  fontWeight: FontWeight.w600,
//                                  fontSize: 18,
//                                  letterSpacing: 0.0,
//                                  color: Color(0xef83d3ea),
//                                ),
//                              ),
//                              onPressed: () {
//                                _alert();
//                              },
//                            )
//                    ]),
                    FavoriteContacts(),
                    RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingCollapsed() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      child: Center(
        child: Text(
          "组队状态",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _floatingPanel() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20.0,
                color: Colors.grey,
              ),
            ]),
        margin: const EdgeInsets.all(24.0),
        child: teamId == 0
            ? Column(
                children: [
                  Text("您当前没有队伍"),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    //TODO 创建队伍
                    onTap: () async {
                      int uid = await StorageUtil.getIntItem('uid');
                      String url =
                          "${Url.url_prefix}/createTeam?uid=" + uid.toString();

                      String token = await StorageUtil.getStringItem('token');

                      final res = await http
                          .post(url, headers: {"Authorization": "$token"});

                      var data =
                          jsonDecode(Utf8Decoder().convert(res.bodyBytes));
                      print(data);
                      getUser();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 16.0),
                          ],
                          color: HotelAppTheme.buildLightTheme().primaryColor,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                            Text(
                              "创建队伍",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    //TODO
                    onTap: () {
                      showApplyDialog(context: context);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 16.0),
                          ],
                          color: HotelAppTheme.buildLightTheme().primaryColor,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                            Text(
                              "加入邀请",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 4,
                  )
                ],
              )
            : Column(
                children: [
                  Text("您正在某队伍中"),
                  Text("队伍成员状态"),
                  Wrap(
                    direction: Axis.vertical,
                    children: userBasicList
                        .map((skill) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 4.0),
                            margin: const EdgeInsets.only(
                                right: 6.0, top: 4.0, bottom: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.black54,
                            ),
                            child: Row(
                              children: [
                                Image(
                                  image: NetworkImage(skill.url),
                                ),
                                Text(skill.name)
                              ],
                            )))
                        .toList(),
                  ),
                  MultiSelectDialogField(
                    items: _items,
                    title: Text(lanIndex == 0 ? "好友列表" : 'Contacts'),
                    selectedColor: Color(0xef83d3ea),
                    // Colors.blue,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.people,
                      color: Colors.blue,
                    ),
                    buttonText: Text(
                      lanIndex == 0 ? " 邀请好友组队" : ' Invite your Friends',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        _selectedAnimals = results;
                      });
                    },
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                        SizedBox(height: 1),
                    _selectedAnimals.length == 0
                        ? SizedBox(
                      height: 1,
                    )
                        : TextButton(
//                            icon: Icon(Icons.check),
//                            iconSize: 30.0,
//                            color: Color(0xef83d3ea), //Colors.blue,
                      child: Text(
                        lanIndex == 0 ? '确认组队' : 'Note',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: Color(0xef83d3ea),
                        ),
                      ),
                      onPressed: () {
                        _alert();
                      },
                    )
                  ]),
                ],
              ));
  }

  void showApplyDialog({BuildContext context}) {
    List<int> apply = [];
    for(int i = 0; i < teamInviteList.length; ++i){
      apply.add(teamInviteList[i].uid);
    }
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => ApplyModal(
        apply: apply,
        onCancelClick: () {},
      ),
    );
  }

  void _alert() {
    String tmp = (lanIndex == 0
        ? "确定和以下好友组队吗?\n\n"
        : "Are you sure to team up with the following friends?\n\n");
    for (var i = 0; i < _selectedAnimals.length; i++) {
      tmp += _selectedAnimals[i].name + "\n";
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(lanIndex == 0 ? '组队确认' : 'Team Confirmation'),
              content: Text(tmp),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(lanIndex == 0 ? "取消" : 'Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(lanIndex == 0 ? "确定" : 'OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}

//data
class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}

List<Animal> _animals = [
  Animal(id: 1, name: "zyt"),
  Animal(id: 2, name: "sqy"),
  Animal(id: 3, name: "gdy"),
  Animal(id: 4, name: "lyb"),
//  Animal(id: 5, name: "Tiger"),
//  Animal(id: 6, name: "Penguin"),
//  Animal(id: 7, name: "Spider"),
//  Animal(id: 8, name: "Snake"),
//  Animal(id: 9, name: "Bear"),
//  Animal(id: 10, name: "Beaver"),
//  Animal(id: 11, name: "Cat"),
//  Animal(id: 12, name: "Fish"),
//  Animal(id: 13, name: "Rabbit"),
//  Animal(id: 14, name: "Mouse"),
//  Animal(id: 15, name: "Dog"),
//  Animal(id: 16, name: "Zebra"),
//  Animal(id: 17, name: "Cow"),
//  Animal(id: 18, name: "Frog"),
//  Animal(id: 19, name: "Blue Jay"),
//  Animal(id: 20, name: "Moose"),
//  Animal(id: 21, name: "Gecko"),
//  Animal(id: 22, name: "Kangaroo"),
//  Animal(id: 23, name: "Shark"),
//  Animal(id: 24, name: "Crocodile"),
//  Animal(id: 25, name: "Owl"),
//  Animal(id: 26, name: "Dragonfly"),
//  Animal(id: 27, name: "Dolphin"),
];

final _items = _animals
    .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
    .toList();
List<Animal> _selectedAnimals = [];
List<Animal> _selectedAnimals2 = [];
List<Animal> _selectedAnimals3 = [];
List<Animal> _selectedAnimals4 = [];
List<Animal> _selectedAnimals5 = [];
final _multiSelectKey = GlobalKey<FormFieldState>();

class TeamInvite {
  TeamInvite({this.uid, this.tid});

  final int tid;
  final int uid;
}

class Position {
  Position({this.x, this.y});

  final double x;
  final double y;
}

class UserBasic {
  UserBasic({this.name, this.url});
  final String name;
  final String url;
}
