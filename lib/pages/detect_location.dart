import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DetectLocation extends StatefulWidget {
  const DetectLocation({Key key}) : super(key: key);
  @override
  _DetectLocationState createState() => _DetectLocationState();
}

class _DetectLocationState extends State<DetectLocation> {
  LocationData position;
  CameraPosition home;
  CameraPosition newPosition;
  initPlatformState() async {
    LocationData location;
    Location _locationService = new Location();
    bool _permission = false;

    bool serviceStatus = await _locationService.serviceEnabled();
    if (serviceStatus) {
      _permission = await _locationService.requestPermission();
      if (_permission) {
        location = await _locationService.getLocation();
      }
    } else {
      bool serviceStatusResult = await _locationService.requestService();
      print("Service status activated after request: $serviceStatusResult");
      if (serviceStatusResult) {
        initPlatformState();
      }
    }

    setState(() {
      position = location;
      home = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14.4746);
    });
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.done),
        label: Text('DONE'),
        onPressed: () {
          Navigator.pop(context,
              [newPosition.target.latitude, newPosition.target.longitude]);
        },
      ),
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Container(
        child: Stack(
          overflow: Overflow.visible,
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: <Widget>[
            GoogleMap(
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              onCameraMove: (value) => newPosition = value,
              initialCameraPosition: home,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Icon(
              Icons.location_on,
              color: Colors.red,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
