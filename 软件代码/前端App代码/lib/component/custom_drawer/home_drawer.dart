import 'dart:io';

import 'package:Hogwarts/pages/login.dart';
import 'package:Hogwarts/pages/profile.dart';
import 'package:Hogwarts/utils/Account.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Hogwarts/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'drawer_animation.dart';
import 'navigation_home_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  String username = '';
  bool isLog = false;
  bool isManager = false;
  String icon = 'assets/unlogin.jpg';
  int lanIndex = GlobalSetting.globalSetting.lanIndex;

  @override
  void initState() {
//    setDrawerListArray();
    getUser();
    super.initState();
  }

  getUser() async {
    String name = await StorageUtil.getStringItem("username");
    String e = await StorageUtil.getStringItem("email");
    int role = await StorageUtil.getIntItem("role");
    String userIcon = await StorageUtil.getStringItem("userIcon");
    if (name != null && e != null && role != null) {
      setState(() {
        username = name;
        icon = userIcon;
        isLog = true;
        isManager = (role == 1) ? true : false;
      });
    } else
      setState(() {
        username =( lanIndex == 0 ? '点击登录' : 'Log In');
        isLog = false;
      });
    print(username);
  }

  void setDrawerListArray() {
    if (isManager) {
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: lanIndex == 0 ? '主页' : 'Home',
          icon: Icon(Icons.home),
        ),
        DrawerList(
          index: DrawerIndex.Finder,
          labelName: lanIndex == 0 ? '浏览' : 'Discovery',
          icon: Icon(Icons.local_library),
        ),
        DrawerList(
          index: DrawerIndex.Project,
          labelName: lanIndex == 0 ? '通讯录' : 'Friends',
          icon: Icon(Icons.desktop_mac),
        ),
        DrawerList(
          index: DrawerIndex.Contact,
          labelName: lanIndex == 0 ? '组队' : 'Team',
          isAssetsImage: true,
          imageName: 'assets/images/supportIcon.png',
        ),
        DrawerList(
          index: DrawerIndex.Setting,
          labelName: lanIndex == 0 ? '设置' : 'Setting',
          icon: Icon(Icons.settings),
        ),
        DrawerList(
          index: DrawerIndex.Manage,
          labelName:  lanIndex == 0 ? '运营管理':'Admin',
          icon: Icon(FontAwesomeIcons.chartBar),
        ),
      ];
    } else
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: lanIndex == 0 ? '主页' : 'Home',
          icon: Icon(Icons.home),
        ),
        DrawerList(
          index: DrawerIndex.Finder,
          labelName: lanIndex == 0 ? '浏览' : 'Discovery',
          icon: Icon(Icons.local_library),
        ),
        DrawerList(
          index: DrawerIndex.Project,
          labelName: lanIndex == 0 ? '通讯录' : 'Friends',
          icon: Icon(Icons.desktop_mac),
        ),
        DrawerList(
          index: DrawerIndex.Contact,
          labelName: lanIndex == 0 ? '组队' : 'Team',
          isAssetsImage: true,
          imageName: 'assets/images/supportIcon.png',
        ),
        DrawerList(
          index: DrawerIndex.Setting,
          labelName: lanIndex == 0 ? '设置' : 'Setting',
          icon: Icon(Icons.settings),
        ),
      ];
  }

  navigateToProfile() async {
    int userId = await StorageUtil.getIntItem("uid");
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => Profile(userId: userId)))
        .then((value) => {updateImage(), updateLan()});
  }

  updateImage() async {
    setState(() {
      icon = 'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png';
    });
    String userIcon = await StorageUtil.getStringItem("userIcon");
    setState(() {
      icon = userIcon;
    });
  }

  updateLan() {
    setState(() {
      lanIndex = GlobalSetting.globalSetting.lanIndex;
    });
    print(lanIndex);
    setDrawerListArray();
  }

  @override
  Widget build(BuildContext context) {
    setDrawerListArray();
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              Positioned.fill(child: AnimatedBackground()),
              onBottom(AnimatedWave(
                height: 180,
                speed: 1.0,
              )),
              onBottom(AnimatedWave(
                height: 120,
                speed: 0.9,
                offset: pi,
              )),
              onBottom(AnimatedWave(
                height: 220,
                speed: 1.2,
                offset: pi / 2,
              )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      if (isLog)
                        navigateToProfile();
                      else
                        Navigator.pushNamed(context, "/login");
//                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: 0)));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(1.0 -
                                  (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(
                                    Tween<double>(begin: 0.0, end: 24.0)
                                            .animate(CurvedAnimation(
                                                parent: widget
                                                    .iconAnimationController,
                                                curve: Curves.fastOutSlowIn))
                                            .value /
                                        360),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.grey.withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: new CircleAvatar(
                                    backgroundImage: !isLog
                                        ? AssetImage(icon)
                                        : NetworkImage(icon),
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.01),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: description()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  isLog
                      ? (lanIndex == 0 ? '登出' : 'LogOut')
                      : (lanIndex == 0 ? '登录' : 'LogIn'),
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: isLog ? Colors.red : Colors.lightGreen,
                ),
                onTap: () {
                  Account.delUserInfo();
                  !isLog
                      ? Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) => LoginScreen()))
                      : Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => NavigationHomeScreen()),
                          (route) => route == null);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget description() {
    if (isLog)
      return Text(
        username,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.white,
          fontSize: 22,
        ),
      );
    else
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Text(
          lanIndex == 0 ? "点击登录" : 'Log In',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.white,
            fontSize: 22,
          ),
        ),
      );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Finder,
  Project,
  Contact,
  Setting,
  Manage
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
