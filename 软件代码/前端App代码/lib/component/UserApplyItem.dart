import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'UserAdminItem.dart';

class UserApplyItem extends StatelessWidget {
  const UserApplyItem(
      {Key key,
        this.userData,
        this.animationController,
        this.animation,
        this.callback,
        this.toggleCallback,
        this.isLarge
      })
      : super(key: key);

  final VoidCallback callback;
  final Function(int) toggleCallback;
  final User userData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool isLarge;

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
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(userData.userIcon),
                                                    radius: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15, top: 4),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            userData.name,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 10, right: 10),
                                                            child: getGenderIcon(),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(top: 6),
                                                          child: Text(
                                                            userData.description,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.grey
                                                                    .withOpacity(0.8)),
                                                          ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 16, bottom: 4),
                                                  child: getToggleSwitch()
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget getGenderIcon() {
    if(userData.gender == "M") return Icon(FontAwesomeIcons.mars, size: 22, color: Colors.blue,);
    else return Icon(FontAwesomeIcons.venus, size: 22, color: Colors.pink,);
  }

  Widget getToggleSwitch() {
    return ToggleSwitch(
      minWidth: 90.0,
      initialLabelIndex: -1,
      cornerRadius: 16.0,
      activeFgColor: Colors.white,
      activeBgColor: Colors.grey.withOpacity(0.5),
      inactiveBgColor: Colors.grey.withOpacity(0.5),
      inactiveFgColor: Colors.white,
      labels: ['接受', '忽略'],
      activeBgColors: [Colors.blue, Colors.pink],
      onToggle: (index) {
        toggleCallback(index);
      },
    );
  }
}
