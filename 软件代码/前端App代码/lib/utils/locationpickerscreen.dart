import 'dart:async';
import 'dart:convert';
import 'package:Hogwarts/component/map_control/amap_controller.x.dart';
import 'package:Hogwarts/pages/friend.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/utils/MyFloatButton.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:Hogwarts/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'locationpickerhelper.dart';
import 'next_latlng.dart';

const _iconSize = 50.0;
double _fabHeight = 16.0;

typedef Future<bool> RequestPermission();
typedef Widget PoiItemBuilder(Poi poi, bool selected);

class LocationPicker extends StatefulWidget {
  const LocationPicker(
      {Key key,
      @required this.requestPermission,
      @required this.poiItemBuilder,
      this.zoomLevel = 16.0,
      this.zoomGesturesEnabled = true,
      this.showZoomControl = false,
      this.centerIndicator,
      this.enableLoadMore = true,
      this.onItemSelected,
      this.fromToLocation,
      this.isNavigate})
      : assert(zoomLevel != null && zoomLevel >= 3 && zoomLevel <= 19),
        super(key: key);

  final fromToLocation;
  final isNavigate;

  /// 请求权限回调
  final RequestPermission requestPermission;

  /// Poi列表项Builder
  final PoiItemBuilder poiItemBuilder;

  /// 显示的缩放登记
  final double zoomLevel;

  /// 缩放手势使能 默认false
  final bool zoomGesturesEnabled;

  /// 是否显示缩放控件 默认false
  final bool showZoomControl;

  /// 地图中心指示器
  final Widget centerIndicator;

  /// 是否开启加载更多
  final bool enableLoadMore;

  /// 选中回调
  final ValueChanged<PoiInfo> onItemSelected;

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>
    with
        SingleTickerProviderStateMixin,
        _BLoCMixin,
        _AnimationMixin,
        NextLatLng {
  // 地图控制器
  AmapController _controller;
  final PanelController _panelController = PanelController();

  // 是否用户手势移动地图
  bool _moveByUser = true;

  // 当前请求到的poi列表
  List<PoiInfo> _poiInfoList = [];

  // 当前地图中心点
  LatLng _currentCenterCoordinate;

  // 页数
  int _page = 1;

  //team
  int teamId = 0;

  bool isFollow = true;
  //team invites
  List<TeamInvite> teamInviteList = [];
  List<UserBasic> userBasicList = [];
  List<int> idList = [];
  List<Position> positionList = [];
  List<String> icons = [
    "https://p.qqan.com/up/2020-9/2020941050205581.jpg",
    "https://p.qqan.com/up/2020-9/202091105822767.jpg",
    "https://p.qqan.com/up/2020-8/2020826954544309.png"
  ];
  List<String> names = ["xtc", "sqy", "lyb"];

  @override
  void initState() {
    super.initState();
//    getUser();
//    getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _countdownTimer?.cancel();
  }

  Timer _countdownTimer;
  var _countdownNum = 0;
  void getPosition() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          _countdownNum++;
        });
//        getUser();
      });
    });
  }

  getUser() async {
    int uid = await StorageUtil.getIntItem('uid');
    String url = "${Url.url_prefix}/getUser?id=" + uid.toString();

    String token = await StorageUtil.getStringItem('token');

    print(token);
    final res = await http.get(url, headers: {"Authorization": "$token"});

//    final data = json.decode(res.body); //中文乱码
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    print(data);
    List<TeamInvite> teamInvite = [];
    for (int j = 0; j < data['teamInvites'].length; ++j) {
      TeamInvite ti = new TeamInvite(
          uid: data['teamInvites'][j]['uid'],
          tid: data['teamInvites'][j]['tid']);
      teamInvite.add(ti);
    }
    print(teamInvite);
    setState(() {
      teamId = data['teamId'];
      teamInviteList = teamInvite;
    });
    if (teamId != 0) getTeam();
  }

  getTeam() async {
    String url = "${Url.url_prefix}/getTeam?tid=" + teamId.toString();
    final res = await http.get(url);
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    List<UserBasic> uss = [];
    List<int> ids = [];
    List<Position> positions = [];
    for (int j = 0; j < data['num']; ++j) {
      int id = data['people'][j];
      ids.add(id);
      positions.add(new Position(
          x: data['position'][j]['x'], y: data['position'][j]['y']));
      UserBasic ub = await getUserBasic(id);
      uss.add(ub);
    }
    setState(() {
      userBasicList = uss;
      idList = ids;
      positionList = positions;
    });
  }

  Future<UserBasic> getUserBasic(int uid) async {
    String url = "${Url.url_prefix}/getUser?id=" + uid.toString();
    final res = await http.get(url);
    var data = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
    return new UserBasic(name: data['name'], url: data['icon']);
  }

  Future<void> _handleSearchRoute() async {
    if (!widget.isNavigate) return;

    final fromLat =
        double.tryParse(widget.fromToLocation._fromLatitudeController.text);
    final fromLng =
        double.tryParse(widget.fromToLocation._fromLongitudeController.text);
    final toLat =
        double.tryParse(widget.fromToLocation._toLatitudeController.text);
    final toLng =
        double.tryParse(widget.fromToLocation._toLongitudeController.text);

    try {
      _controller.addDriveRoute(
        from: LatLng(fromLat, fromLng),
        to: LatLng(toLat, toLng),
        trafficOption: TrafficOption(show: false),
      );
    } catch (e) {
      L.d(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minPanelHeight = 40.0;
    final maxPanelHeight = MediaQuery.of(context).size.height * 0.4;
    return SlidingUpPanel(
        controller: _panelController,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        minHeight: minPanelHeight,
        maxHeight: maxPanelHeight,
        borderRadius: BorderRadius.circular(16),
        onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (maxPanelHeight - minPanelHeight) * .5;
            }),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Stack(
                children: <Widget>[
                  AmapView(
                    zoomLevel: widget.zoomLevel,
                    zoomGesturesEnabled: widget.zoomGesturesEnabled,
                    showZoomControl: widget.showZoomControl,
                    onMapMoveEnd: (move) async {
                      if (_moveByUser) {
                        // 地图移动结束, 显示跳动动画
                        _jumpController
                            .forward()
                            .then((it) => _jumpController.reverse());
                        _search(move.latLng);
                      }
                      _moveByUser = true;
                      // 保存当前地图中心点数据
                      _currentCenterCoordinate = move.latLng;
                      _handleSearchRoute();
                    },
                    onMapCreated: (controller) async {
                      _controller = controller;
                      if (await widget.requestPermission()) {
                        await _showMyLocation();
                        _search(await _controller.getLocation());
                        _handleSearchRoute();
                        await _controller?.addMarker(
                          MarkerOption(
                            latLng: getNextLatLng(),
                            title: '北京${random.nextDouble()}',
                            snippet: '描述${random.nextDouble()}',
                            iconProvider: NetworkImage(
                                "https://p.qqan.com/up/2020-8/2020826954544309.png"),
                            infoWindowEnabled: true,
                            object: '自定义数据${random.nextDouble()}',
                          ),
                        );
//                        await _controller?.addMarkers(
//                            [
//                              for (int i = 0; i < 3; i++)
//                                MarkerOption(
//                                  latLng: getNextLatLng(),
//                                  widget: Column(
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      Text(names[i]),
//                                      Image.network(icons[i]),
//                                    ],
//                                  ),
//                                  title: '北京',
//                                  snippet: '描述',
//                                )
//                            ],
//                          );
                      } else {
                        debugPrint('权限请求被拒绝!');
                      }
                    },
                  ),
                  // 中心指示器
                  Center(
                    child: AnimatedBuilder(
                        animation: _tween,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              _tween.value.dx,
                              _tween.value.dy - _iconSize / 2,
                            ),
                            child: child,
                          );
                        },
                        child: widget.centerIndicator ??
//                          Image(
//                            image: AssetImage('assets/test_icon.png'),
//                          ),
                            Icon(
                              Icons.location_on,
                              size: 24,
                              color: Colors.red,
                            )),
                  ),

                  Positioned(
                    right: 16.0,
                    bottom: _fabHeight + 16.0 + 40 + 100,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.gps_fixed,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _showMyLocation,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                      right: 12.0,
                      bottom: _fabHeight + 16.0 + 110 + 100,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: MyFloatButton(),
                      )),
//                Positioned(
//                  bottom: _fabHeight,
//                  child: Container(
//                    decoration: BoxDecoration(
//                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                      boxShadow: <BoxShadow>[
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.6),
//                          offset: const Offset(4, 4),
//                          blurRadius: 16,
//                        ),
//                      ],
//                    ),
//
//                    child: SizedBox(
//                      height: 32,
//                      width: MediaQuery.of(context).size.width,
//                      child: Container(
//                        color: HotelAppTheme.buildLightTheme()
//                            .backgroundColor,
//                        child: Center(
//                          child: Icon(Icons.keyboard_arrow_up),
//                        ),
//                      )
//                    )
//                  ),
//                )
                ],
              ),
            ),
            // 用来抵消panel的最小高度
//          SizedBox(height: minPanelHeight - 40),
          ],
        ),
//        renderPanelSheet: false,
        panelBuilder: (ScrollController sc) => StreamBuilder<List<PoiInfo>>(
              stream: _poiStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return EasyRefresh(
                    footer: MaterialFooter(),
                    onLoad: widget.enableLoadMore ? _handleLoadMore : null,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: sc,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final poi = data[index].poi;
                        final selected = data[index].selected;
                        return GestureDetector(
                          onTap: () {
                            // 遍历数据列表, 设置当前被选中的数据项
                            for (int i = 0; i < data.length; i++) {
                              data[i].selected = i == index;
                            }
                            // 如果索引是0, 说明是当前位置, 更新这个数据
                            _onMyLocation.add(index == 0);
                            // 刷新数据
                            _poiStream.add(data);
                            // 设置地图中心点
                            _setCenterCoordinate(poi.latLng);
                            // 回调
                            if (widget.onItemSelected != null) {
                              widget.onItemSelected(data[index]);
                            }
                          },
                          child: widget.poiItemBuilder(poi, selected),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
        collapsed: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0)),
          ),
//          margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          child: Center(
            child: Text(
              "探索周边",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
//            Column(
//              children: [
//              SizedBox(
//                height: 32,
//                width: MediaQuery.of(context).size.width,
//                child: Container(
//                  color: HotelAppTheme.buildLightTheme()
//                      .backgroundColor,
//                  child: Center(
//                    child: Icon(Icons.keyboard_arrow_up),
//                  ),
//                )
//            ),
//                StreamBuilder<List<PoiInfo>>(
//                  stream: _poiStream.stream,
//                  builder: (context, snapshot) {
//                    if (snapshot.hasData) {
//                      final data = snapshot.data;
//                      return EasyRefresh(
//                        footer: MaterialFooter(),
//                        onLoad: widget.enableLoadMore ? _handleLoadMore : null,
//                        child: ListView.builder(
//                          padding: EdgeInsets.zero,
////                      controller: scrollController,
//                          shrinkWrap: true,
//                          itemCount: data.length,
//                          itemBuilder: (context, index) {
//                            final poi = data[index].poi;
//                            final selected = data[index].selected;
//                            return GestureDetector(
//                              onTap: () {
//                                // 遍历数据列表, 设置当前被选中的数据项
//                                for (int i = 0; i < data.length; i++) {
//                                  data[i].selected = i == index;
//                                }
//                                // 如果索引是0, 说明是当前位置, 更新这个数据
//                                _onMyLocation.add(index == 0);
//                                // 刷新数据
//                                _poiStream.add(data);
//                                // 设置地图中心点
//                                _setCenterCoordinate(poi.latLng);
//                                // 回调
//                                if (widget.onItemSelected != null) {
//                                  widget.onItemSelected(data[index]);
//                                }
//                              },
//                              child: widget.poiItemBuilder(poi, selected),
//                            );
//                          },
//                        ),
//                      );
//                    } else {
//                      return Center(child: CircularProgressIndicator());
//                    }
//                  },
//                ),
//              ],
//            )

        );
  }

  Future<void> _search(LatLng location) async {
    final poiList = await AmapSearch.instance.searchAround(location);
    _poiInfoList = poiList.map((poi) => PoiInfo(poi)).toList();
    // 默认勾选第一项
    if (_poiInfoList.isNotEmpty) _poiInfoList[0].selected = true;
    _poiStream.add(_poiInfoList);

    // 重置页数
    _page = 1;
  }

  Future<void> _showMyLocation() async {
//    _onMyLocation.add(true);
//    await _controller?.showMyLocation(MyLocationOption(
//      strokeColor: Colors.transparent,
//      fillColor: Colors.transparent,
//    ));
    if (isFollow) {
      await _controller?.showMyLocation(MyLocationOption(
        myLocationType: MyLocationType.Rotate,
      ));
      setState(() {
        isFollow = false;
      });
    } else {
      await _controller?.showMyLocation(MyLocationOption(
        myLocationType: MyLocationType.Show,
      ));
      setState(() {
        isFollow = true;
      });
    }
  }

  Future<void> _setCenterCoordinate(LatLng coordinate) async {
    await _controller.setCenterCoordinate(coordinate);
    _moveByUser = false;
  }

  Future<void> _handleLoadMore() async {
    final poiList = await AmapSearch.instance.searchAround(
      _currentCenterCoordinate,
      page: ++_page,
    );
    _poiInfoList.addAll(poiList.map((poi) => PoiInfo(poi)).toList());
    _poiStream.add(_poiInfoList);
  }
}

mixin _BLoCMixin on State<LocationPicker> {
  // poi流
  final _poiStream = StreamController<List<PoiInfo>>.broadcast();

  // 是否在我的位置
  final _onMyLocation = StreamController<bool>();

  @override
  void dispose() {
    _poiStream.close();
    _onMyLocation.close();
    super.dispose();
  }
}

mixin _AnimationMixin on SingleTickerProviderStateMixin<LocationPicker> {
  // 动画相关
  AnimationController _jumpController;
  Animation<Offset> _tween;

  @override
  void initState() {
    super.initState();
    _jumpController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _tween = Tween(begin: Offset(0, 0), end: Offset(0, -15)).animate(
        CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _jumpController?.dispose();
    super.dispose();
  }
}
