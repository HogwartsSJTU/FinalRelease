import 'dart:math';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:Hogwarts/utils/next_latlng.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:demo_widgets/demo_widgets.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/map_control/amap_controller.x.dart';

final _assetsIcon = AssetImage('https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=%E5%AE%9A%E4%BD%8D%E5%9B%BE%E6%A0%87&step_word=&hs=2&pn=54&spn=0&di=2200&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&istype=0&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=undefined&cs=1070168912%2C3072955312&os=434381118%2C2258794648&simid=0%2C0&adpicid=0&lpn=0&ln=952&fr=&fmq=1605341723603_R&fm=&ic=undefined&s=undefined&hd=undefined&latest=undefined&copyright=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c9505541bb22000001a64b457752.jpg%402o.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bzv55s_z%26e3Bv54_z%26e3BvgAzdH3Fo56hAzdH3FZNzQ9MDIoOA%3D%3D_z%26e3Bip4s&gsm=37&rpstart=0&rpnum=0&islist=&querylist=&force=undefined');

class HomePage extends StatefulWidget{
  HomePage({
    this.fromToLocation,
    this.isNavigate
  });

  final fromToLocation;
  final isNavigate;

  State<StatefulWidget> createState(){
    return RecommendedPage();
  }
}

class RecommendedPage extends State<HomePage> with NextLatLng{
  AmapController _controller;
  bool set = true;

  @override
  void initState() {
    super.initState();
  }

//  _handleMasker() {
//    final marker = await controller.addMarker(
//      MarkerOption(
//        coordinate: LatLng(39.906901,116.397972),
//        iconProvider: AssetImage('images/test_icon.png'),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hogwarts')),
      floatingActionButton: FloatingActionButton(
          onPressed: () => print("FloatingActionButton"),
          child: IconButton(icon: Icon(Icons.add), onPressed: () {setState(() {
            set = !set;
          });}),
          tooltip: "按这么长时间干嘛",
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          // elevation: 6.0,
          // highlightElevation: 12.0,
          shape: CircleBorder()),
      body: DecoratedColumn(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: AmapView(
              mapType: MapType.Satellite,
              showZoomControl: false,
              tilt: 60,
              zoomLevel: 17,
              centerCoordinate: LatLng(29, 119),
              maskDelay: Duration(milliseconds: 500),
              onMapCreated: (controller) async {
                _controller = controller;
                await _controller?.showMyLocation(MyLocationOption(
                  myLocationType: MyLocationType.Rotate,
                ));
                _controller?.setMapType(MapType.Standard);
                _handleSearchRoute();
                await _controller?.addMarker(
                  MarkerOption(
                    latLng: getNextLatLng(),
                    title: '北京${random.nextDouble()}',
                    snippet: '描述${random.nextDouble()}',
                    iconProvider: NetworkImage("https://p.qqan.com/up/2020-8/2020826954544309.png"),
                    infoWindowEnabled: true,
                    object: '自定义数据${random.nextDouble()}',
                  ),
                );
              },
            ),
          ),
          Flexible(
            flex: set ? 0 : 1,
            child: set ?
            DecoratedColumn(
              children: [
                Container(height: 1,)
              ],
            ) :
            DecoratedColumn(
              scrollable: true,
              divider: kDividerZero,
              children: <Widget>[
                BooleanSetting(
                  head: '是否显示定位',
                  onSelected: (value) async {
                    await _controller?.showMyLocation(MyLocationOption(
                      show: value,
                      iconProvider: AssetImage('images/test_icon.png'),
                    ));
                  },
                ),
                DiscreteSetting(
                  head: '选择定位模式',
                  options: <String>[
                    '只定位不移动地图到中心',
                    '定位一次并移动地图到中心',
                    '连续定位并跟随',
                    '连续定位跟随方向',
                  ],
                  onSelected: (String value) async {
                    if (value == '只定位不移动地图到中心') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Show,
                      ));
                    } else if (value == '定位一次并移动地图到中心') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Locate,
                      ));
                    } else if (value == '连续定位并跟随') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Follow,
                      ));
                    } else if (value == '连续定位跟随方向') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Rotate,
                      ));
                    }
                  },
                ),
                DiscreteSetting(
                  head: '选择定位间隔时间',
                  options: <String>[
                    '1秒',
                    '3秒',
                    '5秒',
                  ],
                  onSelected: (String value) async {
                    if (value == '1秒') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Follow,
                        interval: Duration(seconds: 1),
                      ));
                    } else if (value == '3秒') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Follow,
                        interval: Duration(seconds: 3),
                      ));
                    } else if (value == '5秒') {
                      await _controller?.showMyLocation(MyLocationOption(
                        myLocationType: MyLocationType.Follow,
                        interval: Duration(seconds: 5),
                      ));
                    }
                  },
                ),
                ListTile(
                  title: Center(child: Text('获取当前位置经纬度')),
                  onTap: () async {
                    final latLng = await _controller?.getLocation();
                    toast('当前经纬度: ${latLng.latitude}, ${latLng.longitude}');
                  },
                ),
                ListTile(
                  title: Center(child: Text('使用自定义定位图标')),
                  onTap: () async {
                    await _controller?.showMyLocation(MyLocationOption(
                      myLocationType: MyLocationType.Rotate,
                      iconProvider: _assetsIcon,
                    ));
                  },
                ),
                BooleanSetting(
                  head: '是否显示室内地图',
                  onSelected: (value) {
                    _controller?.showIndoorMap(value);
                  },
                ),
                DiscreteSetting(
                  head: '切换地图图层',
                  options: ['正常视图', '卫星视图', '黑夜视图', '导航视图', '公交视图'],
                  onSelected: (value) {
                    switch (value) {
                      case '正常视图':
                        _controller?.setMapType(MapType.Standard);
                        break;
                      case '卫星视图':
                        _controller?.setMapType(MapType.Satellite);
                        break;
                      case '黑夜视图':
                        _controller?.setMapType(MapType.Night);
                        break;
                      case '导航视图':
                        _controller?.setMapType(MapType.Navi);
                        break;
                      case '公交视图':
                        _controller?.setMapType(MapType.Bus);
                        break;
                    }
                  },
                ),
                DiscreteSetting(
                  head: '切换语言',
                  options: ['中文', '英文'],
                  onSelected: (value) {
                    switch (value) {
                      case '中文':
                        _controller?.setMapLanguage(Language.Chinese);
                        break;
                      case '英文':
                        _controller?.setMapLanguage(Language.English);
                        break;
                    }
                  },
                ),
                DiscreteSetting(
                  head: '精度圈边框颜色',
                  options: ['红色', '绿色', '蓝色'],
                  onSelected: (value) {
                    switch (value) {
                      case '红色':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeColor: Colors.red,
                          strokeWidth: 2,
                        ));
                        break;
                      case '绿色':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeColor: Colors.green,
                          strokeWidth: 2,
                        ));
                        break;
                      case '蓝色':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeColor: Colors.blue,
                          strokeWidth: 2,
                        ));
                        break;
                    }
                  },
                ),
                DiscreteSetting(
                  head: '精度圈填充颜色',
                  options: ['红色', '绿色', '蓝色'],
                  onSelected: (value) {
                    switch (value) {
                      case '红色':
                        _controller?.showMyLocation(MyLocationOption(
                          fillColor: Colors.red,
                          strokeWidth: 2,
                        ));
                        break;
                      case '绿色':
                        _controller?.showMyLocation(MyLocationOption(
                          fillColor: Colors.green,
                          strokeWidth: 2,
                        ));
                        break;
                      case '蓝色':
                        _controller?.showMyLocation(MyLocationOption(
                          fillColor: Colors.blue,
                          strokeWidth: 2,
                        ));
                        break;
                    }
                  },
                ),
                DiscreteSetting(
                  head: '精度圈边框宽度',
                  options: ['2', '4', '8'],
                  onSelected: (value) {
                    switch (value) {
                      case '2':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeWidth: 2,
                        ));
                        break;
                      case '4':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeWidth: 4,
                        ));
                        break;
                      case '8':
                        _controller?.showMyLocation(MyLocationOption(
                          strokeWidth: 8,
                        ));
                        break;
                    }
                  },
                ),
                BooleanSetting(
                  head: '是否显示路况信息',
                  onSelected: (value) {
                    _controller?.showTraffic(value);
                  },
                ),
                ListTile(
                  title: Center(child: Text('获取地图中心点')),
                  onTap: () async {
                    final center = await _controller?.getCenterCoordinate();
                    toast(
                        'center: lat: ${center.latitude}, lng: ${center.longitude}');
                  },
                ),
                ListTile(
                  title: Center(child: Text('监听地图移动')),
                  onTap: () {
                    _controller?.setMapMoveListener(
                      onMapMoveStart: (move) async => debugPrint('开始移动: $move'),
                      onMapMoving: (move) async => debugPrint('移动中: $move'),
                      onMapMoveEnd: (move) async => debugPrint('结束移动: $move'),
                    );
                  },
                ),
                ListTile(
                  title: Center(child: Text('添加点击地图监听')),
                  onTap: () {
                    _controller?.setMapClickedListener(
                          (latLng) async {
                        toast(
                          '点击: lat: ${latLng.latitude}, lng: ${latLng.longitude}',
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Center(child: Text('经纬度坐标转屏幕坐标')),
                  onTap: () async {
                    final centerLatLng =
                    await _controller.getCenterCoordinate();
                    final screenPoint =
                    await _controller?.toScreenLocation(centerLatLng);
                    toast('地图中心点对应的屏幕坐标为: $screenPoint');
                  },
                ),
                ListTile(
                  title: Center(child: Text('屏幕坐标转经纬度坐标')),
                  onTap: () async {
                    final screenPoint = Point(250, 250);
                    final latLng =
                    await _controller?.fromScreenLocation(screenPoint);
                    toast('屏幕坐标(250, 250)对应的经纬度坐标为: $latLng');
                  },
                ),
                ListTile(
                  title: Center(child: Text('设置屏幕上的某个像素点为地图中心点')),
                  onTap: () async {
                    final screenPoint = Point(20, 20);
//                    await _controller?.setPointToCenter(screenPoint);
                  },
                ),
                ListTile(
                  title: Center(child: Text('监听位置改变')),
                  onTap: () async {
                    await _controller
                        ?.setMyLocationChangeListener((location) async {
                      final coord = await location.coord;
                      toast(
                        '当前位置: 经度: ${coord.latitude}, 纬度: ${coord.longitude}, 方向: ${await location.bearing}',
                      );
                    });
                  },
                ),
                ListTile(
                  title: Center(child: Text('设置以地图为中心进行缩放')),
                  onTap: () async {
                    await _controller?.setZoomByCenter(true);
                  },
                ),
                ListTile(
                  title: Center(child: Text('限制地图显示范围')),
                  onTap: () async {
                    final southWest = LatLng(40, 116);
                    final northEast = LatLng(42, 118);
                    await _controller?.setMapRegionLimits(southWest, northEast);
                  },
                ),
                ListTile(
                  title: Center(child: Text('获取当前缩放等级')),
                  onTap: () async {
                    toast('当前缩放等级: ${await _controller.getZoomLevel()}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSearchRoute() async {
    if(!widget.isNavigate) return;

    final fromLat = double.tryParse(widget.fromToLocation._fromLatitudeController.text);
    final fromLng = double.tryParse(widget.fromToLocation._fromLongitudeController.text);
    final toLat = double.tryParse(widget.fromToLocation._toLatitudeController.text);
    final toLng = double.tryParse(widget.fromToLocation._toLongitudeController.text);

    try {
      _controller.addDriveRoute(
        from: LatLng(fromLat, fromLng),
        to: LatLng(toLat, toLng),
        trafficOption: TrafficOption(show: true),
      );
    } catch (e) {
      L.d(e);
    }
  }
}

class FromToLocation{
  FromToLocation(
      this._fromLatitudeController,
      this._fromLongitudeController,
      this._toLatitudeController,
      this._toLongitudeController
      );

  final _fromLatitudeController;
  final _fromLongitudeController;

  final _toLatitudeController;
  final _toLongitudeController;
}
