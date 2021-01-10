import 'package:Hogwarts/utils/locationpickerscreen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPickerScreen extends StatefulWidget {
  LocationPickerScreen({
    this.fromToLocation,
    this.isNavigate
  });

  final fromToLocation;
  final isNavigate;

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hogwarts')),
      body: LocationPicker(
        fromToLocation: widget.fromToLocation,
        isNavigate: widget.isNavigate,
        requestPermission: () {
          return Permission.location.request().then((it) => it.isGranted);
        },
        poiItemBuilder: (poi, selected) {
          return ListTile(
            title: Text(poi.title),
            subtitle: Text(poi.address),
            trailing: selected ? Icon(Icons.check) : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
