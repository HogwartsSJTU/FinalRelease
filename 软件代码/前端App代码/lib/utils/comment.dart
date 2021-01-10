import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/detail/RatingBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Hogwarts/component/design_course/design_course_app_theme.dart';
import 'package:Hogwarts/theme/app_theme.dart';


class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{

  var ratingValue;
  List images = [];
  var _image;
  var imageNum = 0;
  bool ifImageChanged = false;

  String value() {
    if (ratingValue == null) {
      return '评分：4.5 分';
    } else {
      return '评分：$ratingValue  分';
    }
  }

  Timer _countdownTimer;
  var _countdownNum = 0;
  void getPosition(){
  setState(() {
    if (_countdownTimer != null) {
      return;
    }
    _countdownTimer =
    new Timer.periodic(new Duration(seconds: 1), (timer){
      setState(() {
        _countdownNum ++;
      });
    });
  });

  /*const timeout = const Duration(seconds: 1);
  Timer.periodic(timeout, (timer) { //callback function
  //1s 回调一次
  print('afterTimer='+DateTime.now().toString());

  timer.cancel();  // 取消定时器*/
  }


  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
        images.add(image);
        imageNum++;
      });
      setState(() {
        ifImageChanged = true;
      });
    }
  }

  List<Widget> Boxs() => List.generate(imageNum+1, (index) {
    return index == imageNum? Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1)
      ),
      width: MediaQuery.of(context).size.width*0.28,
      height: MediaQuery.of(context).size.width*0.28,
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(Icons.add_a_photo),
        onPressed: (){
          getImage();
        },
      ),
    ):
    Container(
      width: MediaQuery.of(context).size.width*0.28,
      height: MediaQuery.of(context).size.width*0.28,
      alignment: Alignment.center,
      child: Image.file(images[index]),
      //child: Image.network('http://p.qqan.com/up/2020-9/2020941050205581.jpg')
    );
  });

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(' $_countdownNum')),
//      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width:170,
              height: 60,
              alignment: Alignment.center,
              child: RatingBar(
                  value: 4.5,
                  size: 30,
                  padding: 5,
                  nomalImage: 'assets/star_nomal.png',
                  selectImage: 'assets/star.png',
                  selectAble: true,
                  onRatingUpdate: (value) {
                    setState(() {
                      ratingValue = value;
                    });
                  },
                  maxRating: 5,
                  count: 5
              ),
            ),
            Text(
                value(),
                style: TextStyle(fontSize: 18)
            ),
            Container(
              padding: EdgeInsets.all(18.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: '请输入你的评论',
                ),
                maxLines: 8,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(18.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    runSpacing: 5,
                    children: Boxs(),
                  ),
                )
              ],
            ),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: DesignCourseAppTheme.nearlyBlue,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: DesignCourseAppTheme.nearlyBlue
                          .withOpacity(0.5),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: TextButton(
                  child: Text(
                    '提交',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.0,
                      color: DesignCourseAppTheme.nearlyWhite,
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}