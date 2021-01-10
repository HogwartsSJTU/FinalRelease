import 'package:Hogwarts/pages/login.dart';
import 'package:Hogwarts/pages/signup.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Hogwarts/theme/app_theme.dart';
import 'package:Hogwarts/utils/data.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:Hogwarts/component/custom_drawer/navigation_home_screen.dart';

// TODO LIST
// TODO 登录注册；个人中心；个人信息维护；浏览；设置；颜色语言设置；路由控制；游记管理；组队管理；主页
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));

  await enableFluttifyLog(false);
  await AmapService.instance.init(
    iosKey: '7a04506d15fdb7585707f7091d715ef4',     //虚假的key，iOS未配置
//    androidKey: '55016db318a343ffbad04732acb09b06', //gdy
//    androidKey: '4be70ed29d5114f7c1a464f256008888', //xtc
    androidKey: '45cffc60503f61d4b99f6f8c5da8e8d5', //sqy
    webApiKey: 'e69c6fddf6ccf8de917f5990deaa9aa2',  //虚假的key，web未配置
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'HogwartsMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xFFFEF9EB),
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => NavigationHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
      },
    );
  }
}
