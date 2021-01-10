import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Hogwarts/component/custom_drawer/navigation_home_screen.dart';
import 'package:Hogwarts/theme/constants.dart';
import 'package:http/http.dart' as http;
import 'package:Hogwarts/utils/config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool getAccess = true;
  FlutterToast flutterToast;
  Color emailTextColor = Color(0xFF6CA8F1);
  Color passTextColor = Color(0xFF6CA8F1);
  Color phoneTextColor = Color(0xFF6CA8F1);
  Color disTextColor = Color(0xFF6CA8F1);
  Color nameTextColor = Color(0xFF6CA8F1);
  int lanIndex = GlobalSetting.globalSetting.lanIndex;
  TextEditingController emailAddressControl = TextEditingController();

  String get emailAddress => emailAddressControl.text;

  TextEditingController passwordControl = TextEditingController();

  String get password => passwordControl.text;

  TextEditingController districtControl = TextEditingController();

  String get district => districtControl.text;

  TextEditingController numberControl = TextEditingController();

  String get phoneNum => numberControl.text;

  TextEditingController nameControl = TextEditingController();

  String get name => nameControl.text;

  checkAllFilled() {
    setState(() {
      if (emailAddressControl.text == '' ||
          !emailAddressControl.text.contains('@')) {
        emailTextColor = Color(0xDFB0C4DE); //red[300];
//        getAccess = false;
      } else {
        emailTextColor = Color(0xFF6CA8F1);
      }
      if (passwordControl.text == '') {
        passTextColor = Color(0xDFB0C4DE);
        getAccess = false;
      } else {
        passTextColor = Color(0xFF6CA8F1);
      }
      if (nameControl.text == '' || nameControl.text.length < 2) {
        nameTextColor = Color(0xDFB0C4DE);
        getAccess = false;
      } else {
        nameTextColor = Color(0xFF6CA8F1);
      }
      if (districtControl.text == '' || districtControl.text.length < 6) {
        disTextColor = Color(0xDFB0C4DE);
//        getAccess = false;
      } else {
        disTextColor = Color(0xFF6CA8F1);
      }
      if (numberControl.text == '' || numberControl.text.length != 11) {
        phoneTextColor = Color(0xDFB0C4DE);
        getAccess = false;
      } else {
        phoneTextColor = Color(0xFF6CA8F1);
      }
    });

    if (getAccess == true) {
      insertData();
    }
    getAccess = true;
  }
  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }
  insertData() async {
    String url = "${Url.url_prefix}/signup";
    var res = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
//      "email": emailAddress,
//      "address": district,
      "password": password,
      "phone": phoneNum,
      "name": name,
      "address": "Shanghai Jiao Tong University"
    });
    _showToast();
    //清空路由堆栈，压入新的主页
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context)=> NavigationHomeScreen()),
            (route)=>route==null
    );
  }

  _showToast() {
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
          Text(lanIndex == 0 ?"注册成功 请重新登录":'Registration successful, please login again'),
        ],
      ),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'邮箱':'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: emailTextColor,
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
            controller: emailAddressControl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: lanIndex == 0 ?'输入邮箱':'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'昵称':'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: nameTextColor,
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
            controller: nameControl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                Icons.perm_identity,
                color: Colors.white,
              ),
              hintText: lanIndex == 0 ?'输入昵称':'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'地址':'Address',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: disTextColor,
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
            controller: districtControl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.white,
              ),
              hintText: lanIndex == 0 ?'输入地址':'Enter your Address',
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
              hintText: lanIndex == 0 ?'输入密码':'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildphoneNumTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lanIndex == 0 ?'手机号':'Telephone',
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
            controller: numberControl,
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

  Widget _buildCreateAccountBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          checkAllFilled();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          lanIndex == 0 ?'注册':'Create Account',
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

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () {
        //路由替换，将注册页替换为登录页
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: lanIndex == 0 ?'已有账户? ':'Already have an Account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: lanIndex == 0 ?'登录':'Sign In',
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
                        lanIndex == 0 ?'注册':'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildName(),
                      SizedBox(height: 10.0),
                      _buildphoneNumTF(),
                      SizedBox(height: 10.0),
                      _buildPasswordTF(),
//                      SizedBox(height: 10.0),
//                      _buildCityName(),
//                      SizedBox(height: 10.0),
//                      _buildEmailTF(),
                      SizedBox(height: 10.0),
                      _buildCreateAccountBtn(),
                      SizedBox(height: 10.0),
                      _buildLoginBtn(),
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
