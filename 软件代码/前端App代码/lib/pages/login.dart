import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Hogwarts/component/custom_drawer/navigation_home_screen.dart';
import 'package:Hogwarts/theme/constants.dart';
import 'package:Hogwarts/pages/signup.dart';
import 'package:Hogwarts/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Hogwarts/utils/Account.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Hogwarts/utils/config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  FlutterToast flutterToast;

  Color phoneTextColor = Color(0xFF6CA8F1);
  Color passTextColor = Color(0xFF6CA8F1);
  TextEditingController telePhoneControl = TextEditingController();

  String get telePhone => telePhoneControl.text;

  TextEditingController passwordControl = TextEditingController();

  String get password => passwordControl.text;
  int lanIndex = GlobalSetting.globalSetting.lanIndex;
  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.clear),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastSuccess(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  authentication() async {
    try {
      String url = "${Url.url_prefix}/login";
      var res = await http.post(Uri.encodeFull(url), headers: {
        "Accept": "application/json;charset=UTF-8"
      }, body: {
        "phone": telePhone,
        "password": password,
      });
      var response = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
      if(response['message'] == "登录失败,密码错误"){
        _showToast( lanIndex == 0 ?"用户名或密码错误":'Wrong username or password');
        setState(() {
          phoneTextColor = Color(0xDFB0C4DE);
          passwordControl.text = "";
        });
        return;
      }
      if(response['message'] == "登录失败,用户不存在"){
        _showToast(lanIndex == 0 ?"该账户还未注册":'The account is not yet registered');
        setState(() {
          telePhoneControl.text = "";
          passwordControl.text = "";
        });
        return;
      }
      if(response['user']['role'] == -1){
        _showToast(lanIndex == 0 ?"该账户已被禁用":'The account has been disabled');
        setState(() {
          phoneTextColor = Color(0xDFB0C4DE);
          passTextColor = Color(0xDFB0C4DE);
        });
        return;
      }
      print("登录成功");
      _showToastSuccess(lanIndex == 0 ?"欢迎回来 ":"Welcome back" + response["user"]["name"].toString());
      Account.saveUserInfo(response["user"]);
      Account.saveToken(response["token"]);
    } catch (e) {
      print("账号或密码错误");
    }
    //清空路由堆栈，压入新的主页
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context)=> NavigationHomeScreen()),
            (route)=>route==null
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'手机':'Telephone',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: phoneTextColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 40.0,
          child: TextField(
            key: Key('phone'),
            controller: telePhoneControl,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: lanIndex == 0 ?'输入手机号':'Enter your Phone number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'密码':'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: passTextColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 40.0,
          child: TextField(
            key: Key('password'),
            controller: passwordControl,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: lanIndex == 0 ?'请输入密码':'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
//        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          lanIndex == 0 ?'忘记密码?':'Forget Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            lanIndex == 0 ?'记住我':'Remember Me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        key: Key('login'),
        elevation: 5.0,
        onPressed: () {
          authentication();

          print("Pressed log IN");
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          lanIndex == 0 ?'登录':'Log In',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          lanIndex == 0 ?'- 或 -':'- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        //路由替换，将登录页替换为注册页
        Navigator.pushReplacementNamed(context, '/signUp');
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: lanIndex == 0 ?'没有账号? ':'Don\'t have an Account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: lanIndex == 0 ?'注册':'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 80.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        lanIndex == 0 ?'登录':'Sign In',
                        key: Key('signin'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildEmailTF(),
                      SizedBox(height: 10.0),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
//                        _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
//                      _buildSignInWithText(),
//                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
