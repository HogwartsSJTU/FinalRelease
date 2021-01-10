import 'package:Hogwarts/component/hotel_booking/hotel_home_screen.dart';
import 'package:Hogwarts/pages/admin.dart';
import 'package:Hogwarts/pages/drawpoint_example.dart';
import 'package:Hogwarts/pages/home.dart';
import 'package:Hogwarts/pages/locationpicker_example.dart';
import 'package:Hogwarts/theme/app_theme.dart';
import 'package:Hogwarts/utils/comment.dart';

import 'package:flutter/material.dart';
import 'drawer_user_controller.dart';
import 'home_drawer.dart';
import 'package:Hogwarts/pages/friend.dart';
import 'package:Hogwarts/pages/contact_screen.dart';
import 'package:Hogwarts/pages/settings_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  NavigationHomeScreen({
    this.drawerIndex = DrawerIndex.HOME,
    this.isNavigate = false,
    this.fromToLocation
  });

  final fromToLocation;
  final isNavigate;
  final DrawerIndex drawerIndex;

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = widget.drawerIndex;
    setIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width > 1080 ? 300 : MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void setIndex() {
    if (drawerIndex == DrawerIndex.HOME) {
//        screenView = HomePage(isNavigate: widget.isNavigate, fromToLocation: widget.fromToLocation,);
        screenView = HomePage(isNavigate: widget.isNavigate, fromToLocation: widget.fromToLocation,);
    } else if (drawerIndex == DrawerIndex.Finder) {
        screenView = HotelHomeScreen();
    } else if (drawerIndex == DrawerIndex.Project) {
        screenView = FriendPage();
//      screenView = UserListScreen();
    } else if (drawerIndex == DrawerIndex.Contact) {
//        screenView = HelpSection();
//        screenView = DrawPointScreen();
      screenView = LocationPickerScreen();
    } else if (drawerIndex == DrawerIndex.Setting) {

        screenView = SettingsScreen();
//        screenView = CommentScreen();
    } else {
      //do in your way......
    }
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomePage();
//          screenView = LocationPickerScreen();
        });
      } else if (drawerIndex == DrawerIndex.Finder) {
        setState(() {
          screenView = HotelHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.Project) {
        setState(() {
          screenView = FriendPage();
//          screenView =  UserListScreen();
        });
      } else if (drawerIndex == DrawerIndex.Contact) {
        setState(() {
//          screenView = HelpSection();
//          screenView = DrawPointScreen();
          screenView = LocationPickerScreen();
        });
      } else if (drawerIndex == DrawerIndex.Setting) {
        setState(() {
//          screenView = SettingsScreen();
          screenView = DrawPointScreen();
//          screenView = CommentScreen();
        });
      } else {
        setState(() {
          screenView = AdminPage();
        });
        //do in your way......
      }
    }
  }
}
