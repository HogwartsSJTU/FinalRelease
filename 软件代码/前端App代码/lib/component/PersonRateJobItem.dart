import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/pages/diary.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PersonRateJobItem extends StatelessWidget {
  const PersonRateJobItem(
      {Key key,
        this.jobData,
        this.watcher,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final VoidCallback callback;
  final int watcher;
  final Diary jobData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                      color: HotelAppTheme.buildLightTheme()
                          .backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 3, right: 7.0, top: 4.0, bottom: 4.0),
                                  margin: const EdgeInsets.only(right: 12.0, top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, size: 16, color: Colors.black54,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                            jobData.createTime.substring(0,10),
                                            style: TextStyle(height: 1.2, fontSize: 14,)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Offstage(
                                  offstage: watcher != jobData.userId,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        //TODO
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DiaryScreen(diary: jobData, isEdit: true,)));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              color: Colors.blueGrey,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, color: Colors.white, size: 18,),
                                                Text("编辑", style: TextStyle(color: Colors.white),)
                                              ],
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 16,),
                                      InkWell(
                                        //TODO
                                        onTap: (){

                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              color: Colors.blueGrey,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.white, size: 18,),
                                                Text("删除", style: TextStyle(color: Colors.white),)
                                              ],
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 4,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              children: <Widget>[
                                Text(jobData.context,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey
                                          .withOpacity(0.8)),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 4),
                              child: Wrap(
                                children: jobData.pictures.map((skill) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                                  margin: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.black54,
                                  ),
                                  child:
                                    Image(image: AssetImage(skill),)
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Diary {
  Diary(
      this.diaryId,         //游记id
      this.userId,
      this.context,       //游记内容
      this.pictures,            //游记图片数组
      this.createTime         //游记时间
      );
  final int diaryId;
  final int userId;
  final String context;
  final List<String> pictures;
  final String createTime;
}
