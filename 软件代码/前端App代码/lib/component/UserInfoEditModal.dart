import 'dart:ui';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Hogwarts/component/LiteSwitch.dart';
import 'package:Hogwarts/component/OSS_Uploader.dart';
import 'package:Hogwarts/utils//config.dart';
import 'package:Hogwarts/utils//StorageUtil.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserInfoEditModal extends StatefulWidget {
  const UserInfoEditModal(
      {Key key,
        this.userInfo,
        this.onApplyClick,
        this.onCancelClick,
      })
      : super(key: key);

  final FoundationInfo userInfo;
  final Function(FoundationInfo, bool, File) onApplyClick;

  final Function onCancelClick;
  @override
  _UserInfoEditModalState createState() => _UserInfoEditModalState();
}

class _UserInfoEditModalState extends State<UserInfoEditModal>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final ValueNotifier<bool> switchState = new ValueNotifier<bool>(true);

  FoundationInfo userInfo = FoundationInfo(
    name: '',
    gender: 'M',
    age: 0,
    phone: '',
    address: '',
    description: '',
    image: 'http://freelancer-images.oss-cn-beijing.aliyuncs.com/blank.png'
  );
  final picker = ImagePicker();
  var _image;
  bool ifImageChanged = false;
  int lanIndex = GlobalSetting.globalSetting.lanIndex;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController.forward();
    super.initState();
    setState(() {
      userInfo = widget.userInfo;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
        _image = image;
      });
      setState(() {
        ifImageChanged = true;
      });
    }
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      lanIndex == 0 ?'编辑资料':'Edit',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 24, bottom: 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              !ifImageChanged
                                                  ? CircleAvatar(
                                                backgroundImage: NetworkImage(userInfo.image),
                                                radius: 50,
                                              )
                                                  : CircleAvatar(
                                                backgroundImage: FileImage(_image),
                                                radius: 50,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 11,
                                            right: 140,
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.camera, size: 30, color: Colors.orangeAccent,),
                                                onPressed: getImage,
                                                tooltip: lanIndex == 0 ?'选择头像':'Choose Avatar',
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                            child: SizedBox(
                                              width: 80,
                                              child: Text(
                                                lanIndex == 0 ? '昵称':'Name',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFFFF),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.35),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: TextField(
                                                  controller: TextEditingController()
                                                    ..text = userInfo.name,
                                                  onChanged: (String txt) {
                                                    userInfo.name = txt;
                                                  },
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  cursorColor: HexColor('#54D3C2'),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: lanIndex == 0 ?'用户名':'User Name',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 180,
                                          child: Row(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                                  child: SizedBox(
                                                    width: 65,
                                                    child: Text(
                                                      lanIndex == 0 ?'性别':'Gender',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              LiteSwitch(
                                                switchState: switchState,
                                                initValue: userInfo.gender == 'M'? true : false,
                                                textSize: 14.0,
                                                iWidth: 80,
                                                iHeight: 30,
                                                textOn: lanIndex == 0 ?'男性':'Male',
                                                textOff: lanIndex == 0 ?'女性':'Female',
                                                colorOn: Colors.blueAccent,
                                                colorOff: Colors.pinkAccent,
                                                iconOn: FontAwesomeIcons.mars,
                                                iconOff: FontAwesomeIcons.venus,
                                                onChanged: (bool state) {
                                                  setState(() {
                                                    if(userInfo.gender == 'M') userInfo.gender = 'F';
                                                    else userInfo.gender = 'M';
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                                  child: SizedBox(
                                                    width: 65,
                                                    child: Text(
                                                      lanIndex == 0 ?'年龄':'Age',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                                  child: InkWell(
                                                    onTap: (){
                                                      showPickerNumber(context);
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFFFFF),
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: Colors.grey.withOpacity(0.35),
                                                              offset: const Offset(2, 2),
                                                              blurRadius: 8.0),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 16, right: 16),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(userInfo.age.toString(), style: TextStyle(fontSize: 18)),
                                                                Text(lanIndex == 0 ?" 岁":'', style: TextStyle(fontSize: 17),)
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                            child: SizedBox(
                                              width: 80,
                                              child: Text(
                                                lanIndex == 0 ?'电话':'Tele',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFFFF),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.35),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: TextField(
                                                  controller: TextEditingController()
                                                    ..text = userInfo.phone,
                                                  onChanged: (String txt) {
                                                    userInfo.phone = txt;
                                                  },
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  cursorColor: HexColor('#54D3C2'),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: lanIndex == 0 ?'电话号码':'Phone Number',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                            child: SizedBox(
                                              width: 80,
                                              child: Text(
                                                lanIndex == 0 ?'地址':'Address',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFFFF),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.35),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: TextField(
                                                  controller: TextEditingController()
                                                    ..text = userInfo.address,
                                                  onChanged: (String txt) {
                                                    userInfo.address = txt;
                                                  },
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  cursorColor: HexColor('#54D3C2'),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: lanIndex == 0 ?'地址':'Address',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, top: 8),
                                          child: Text(
                                            lanIndex == 0 ?'个人描述':'Description',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black54
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.35),
                                                    offset: const Offset(2, 2),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: TextField(
                                                controller: TextEditingController()
                                                  ..text = userInfo.description,
                                                onChanged: (String txt) {
                                                  userInfo.description = txt;
                                                },
                                                maxLines: 5,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                cursorColor: HexColor('#54D3C2'),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: lanIndex == 0 ?'介绍一下你自己吧~':'Description',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 8),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      blurRadius: 8,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      onApplyClick();
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        lanIndex == 0 ?'保存': 'Apply',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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

  onApplyClick() async {
    if(ifImageChanged){
      String name = await Uploader.uploadImage(_image);
      setState(() {
        userInfo.image = "http://freelancer-images.oss-cn-beijing.aliyuncs.com/" + name;
      });
      widget.onApplyClick(userInfo, ifImageChanged, _image);
    }
    else{
      widget.onApplyClick(userInfo, false, null);
    }
    updateUserInfo();
  }

  updateUserInfo() async {
    StorageUtil.setStringItem("userIcon", userInfo.image);

    String url = "${Url.url_prefix}/updateUserInfo";
    int userId = await StorageUtil.getIntItem("uid");
    String token = await StorageUtil.getStringItem('token');
    http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json;charset=UTF-8","Authorization": "$token"
    }, body: {
      "userId": userId.toString(),
      "name": userInfo.name,
      "gender": userInfo.gender,
      "age": userInfo.age.toString(),
      "address": userInfo.address,
      "phone": userInfo.phone,
      "description": userInfo.description,
      "image": userInfo.image,
    });
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 100, jump: 1),
        ]),
        selecteds: [userInfo.age - 1],
        hideHeader: false,
        title: Text(lanIndex == 0 ?"选择年龄":'Choose Age'),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            userInfo.age = picker.getSelectedValues()[0];
          });
        }
    ).showModal(context);
  }
}

class FoundationInfo{
  FoundationInfo({
    this.name,
    this.gender,
    this.age,
    this.address,
    this.phone,
    this.description,
    this.image
  });

  String name;
  String gender;
  int age;
  String phone;
  String address;
  String description;
  String image;
}
