import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  final LocationData location;

  const MapSample({Key key, this.location}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  LocationData location;
  CameraPosition home;
  @override
  @override
  void initState() {
    setState(() {
      location = widget.location;
      home = CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 14.4746);
    });
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: home,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        
      ),
    );
  }
}
