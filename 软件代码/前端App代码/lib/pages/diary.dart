import 'dart:io';
import 'package:Hogwarts/component/PersonRateJobItem.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/detail/RatingBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Hogwarts/component/design_course/design_course_app_theme.dart';
import 'package:Hogwarts/theme/app_theme.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({this.diary, this.isEdit});

  final bool isEdit;
  final Diary diary;

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        images.add(image);
        imageNum++;
      });
      setState(() {
        ifImageChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('游记详情')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                            Text(
//                              jobData.projectName,
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                fontWeight: FontWeight.w600,
//                                fontSize: 20,
//                              ),
//                            ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 3, right: 7.0, top: 4.0, bottom: 4.0),
                          margin: const EdgeInsets.only(
                              right: 12.0, top: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.black54,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                    widget.diary.createTime.substring(0, 10),
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: 14,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        Text(
                          widget.diary.context,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        children: widget.diary.pictures
                            .map((skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 4.0),
                                margin: const EdgeInsets.only(
                                    right: 6.0, top: 4.0, bottom: 4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black54,
                                ),
                                child: Image(
                                  image: AssetImage(skill),
                                )))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 36, right: 36, bottom: 16, top: 36),
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
//                              onApplyClick();
                            },
                            child: Center(
                              child: Text(
                                widget.isEdit ? "保存" : "编辑",
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
          ],
        ),
      ),
    );
  }
}
