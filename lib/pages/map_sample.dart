import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Marker> allMarkers = [];

  void createExposedMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            markerId: MarkerId(
                'Exposed Element ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Exposed Element Reported By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ExposedDialog(data: i.data));
              },
            ),
            position: LatLng(i.data['lattitude'], i.data['longitude'])));
      });
    }
  }

  void createDamagedMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            markerId: MarkerId(
                'Damage ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Damages Reported By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DamageDialog(data: i.data));
              },
            ),
            position: LatLng(i.data['lattitude'], i.data['longitude'])));
      });
    }
  }

  void createWaterMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            markerId: MarkerId(
                'Water Level ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Water Level Reported By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        WaterDialog(data: i.data));
              },
            ),
            position: LatLng(i.data['lattitude'], i.data['longitude'])));
      });
    }
  }

  Location _locationService = new Location();
  initPlatformState() async {
    LocationData llocation;
    // Platform messages may fail, so we use a try/catch PlatformException.

    bool serviceStatus = await _locationService.serviceEnabled();
    //print("Service status: $serviceStatus");
    if (serviceStatus) {
      llocation = await _locationService.getLocation();
    } else {
      bool serviceStatusResult = await _locationService.requestService();
      print("Service status activated after request: $serviceStatusResult");
      if (serviceStatusResult) {
        initPlatformState();
      }
    }

    setState(() {
      location = llocation;
      home = CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 14.4746);
    });
  }

  @override
  void initState() {
    if (widget.location == null) {
      initPlatformState();
    }
    else{
      setState(() {
      location = widget.location;
      home = CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 14.4746);
    });
    }
    
    var exposedStream =
        Firestore.instance.collection('exposed_elements').getDocuments();
    var damageStream = Firestore.instance.collection('damages').getDocuments();
    var waterLevel =
        Firestore.instance.collection('water_level').getDocuments();
    Future.wait([exposedStream, damageStream, waterLevel])
        .then((List<QuerySnapshot> responses) => {
              print('hey'),
              createExposedMarkers(responses[0].documents),
              createDamagedMarkers(responses[1].documents),
              createWaterMarkers(responses[2].documents)
            });
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: home,
        markers: Set.from(allMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

class ExposedDialog extends StatelessWidget {
  final Map data;
  ExposedDialog({this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(Consts.padding),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'Exposed Elements',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reported by ' +
                  data['name'] +
                  '\nContact ' +
                  data['phone'] +
                  '\n\n' +
                  'No. of Residents: ' +
                  data['no_residents'] +
                  '\n' +
                  'No. of Elderly: ' +
                  data['no_elderly'] +
                  '\n'
                  'No. with Limited Mobilty: ' +
                  data['no_ability'] +
                  '\n' +
                  'Age Range: ' +
                  double.parse(data['l_age']).toInt().toString() +
                  ' to ' +
                  double.parse(data['u_age']).toInt().toString() +
                  '\n' +
                  '\nDescription: \n' +
                  data['description'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text('GO BACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DamageDialog extends StatelessWidget {
  final Map data;
  DamageDialog({this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(Consts.padding),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'Damages',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reported by ' +
                      data['name'] +
                      '\nContact ' +
                      data['phone'] +
                      '\n\n' +
                      'View Type: ' +
                      data['view_type'] +
                      '\n' +
                      'Damage Type: ' +
                      data['damage_type'] +
                      '\n'
                      'No. of people invloved: ' +
                      data['no_involved'] +
                      '\n' +
                      '\nImage Link: \n' //+
                  //data['file_name']
                  ,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text('GO BACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterDialog extends StatelessWidget {
  final Map data;
  WaterDialog({this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(Consts.padding),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'Water Level',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reported by ' +
                  data['name'] +
                  '\nContact ' +
                  data['phone'] +
                  '\n\n' +
                  'Water Level: ' +
                  data['water_level'] +
                  'CM' +
                  '\n' +
                  '\nImage Link: \n',
              //data['file_name'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text('GO BACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
}
