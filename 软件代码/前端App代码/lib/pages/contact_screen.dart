import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  int lanIndex = GlobalSetting.globalSetting.lanIndex;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(lanIndex == 0 ?'联系我们':'Contact Us')),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
              child: Image.asset(
                'assets/contactus2.png',
                height: 250,
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            lanIndex == 0 ?'有任何问题\n请联系我们':'Have an issue or query? \n Feel free to contact us',
            style: TextStyle(fontSize: 22.0, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 105,
                  width: 150,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.alternate_email,
                          color: Colors.orange, size: 50),
                      Text(
                        lanIndex == 0 ?'写信给我们':'Write to us:',
                        style: TextStyle(color: Colors.orange),
                      ),
                      Text('Hogwarts@sjtu.edu.cn')
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 105,
                  width: 150,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.call, color: Colors.orange, size: 50),
                      Text(lanIndex == 0 ?'请致电：':'Call us:', style: TextStyle(color: Colors.orange)),
                      Text('13879517488')
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 105,
                  width: 150,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.help_outline, color: Colors.orange, size: 50),
                      Text(lanIndex == 0 ?'问题':'FAQs', style: TextStyle(color: Colors.orange)),
                      Text(lanIndex == 0 ?'常见问题':'Frequently Asked Questions',
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 105,
                  width: 150,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.orange, size: 50),
                      Text(lanIndex == 0 ?'地址':'Locate us:',
                          style: TextStyle(color: Colors.orange)),
                      Text(
                        lanIndex == 0 ?'请见地图':'Find us out on Our Maps',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(child: Text('Copyright (c) Naha Developers')),
          Center(child: Text('Developed by Arunesh Naha'))
        ],
      ),
    );
  }
}
