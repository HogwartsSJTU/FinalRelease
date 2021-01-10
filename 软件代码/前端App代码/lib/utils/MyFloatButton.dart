import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:unicorndial/unicorndial.dart';

class MyFloatButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyFloatButtonState();
}

class _MyFloatButtonState extends State<MyFloatButton> {
  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption1(iconData: Icons.event_busy, onPressed:() {}, tag: "关闭"));
    children.add(_profileOption2(iconData: Icons.exit_to_app, onPressed: (){}, tag: "打开"));
//    children.add(_profileOption(iconData: Icons.delete_outline, onPressed: () {}, tag: "删除"));

    return children;
  }

  Widget _profileOption1({IconData iconData, Function onPressed, String tag}) {
    return UnicornButton(
      currentButton: FloatingActionButton(
        backgroundColor: Colors.white,
        mini: true,
        child: SizedBox(height: 30,width: 30, child: Image.network("https://p.qqan.com/up/2020-8/2020826954544309.png"),),
        tooltip: tag,
        onPressed: onPressed,
        heroTag: tag,
      ),
    );
  }
  Widget _profileOption2({IconData iconData, Function onPressed, String tag}) {
    return UnicornButton(
      currentButton: FloatingActionButton(
        backgroundColor: Colors.white,
        mini: true,
        child: SizedBox(height: 30,width: 30, child: Image.network("https://p.qqan.com/up/2020-9/2020941050205581.jpg"),),
        tooltip: tag,
        onPressed: onPressed,
        heroTag: tag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      UnicornDialer(
        parentButtonBackground: Colors.white,
        orientation: UnicornOrientation.HORIZONTAL,
        parentButton: Icon(Icons.group, color: Colors.blue,),
        childButtons: _getProfileMenu(),
      );
  }
}
