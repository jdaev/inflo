import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inflo/pages/map_sample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inflo/volunteer/life_threat.dart';
import 'package:location/location.dart';
import 'package:inflo/volunteer/hazard.dart';
import 'package:inflo/volunteer/facilities.dart';

class VolunteerMap extends StatefulWidget {
  final String uid;
  final String uname;
  final String phone;
  const VolunteerMap({Key key, this.uid, this.uname, this.phone})
      : super(key: key);
  @override
  _VolunteerMapState createState() => _VolunteerMapState();
}

class _VolunteerMapState extends State<VolunteerMap> {
  LocationData location;
  CameraPosition home;
  Timer timer;
  List<Marker> allMarkers = [];
  Completer<GoogleMapController> _controller = Completer();
  bool active = false;
  Color activityColor = Colors.red;
  void createHazardsMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            markerId: MarkerId(
                'Hazards ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Hazards Reported By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => HazardDialog(
                          data: i.data,
                          docId: i.documentID,
                        ));
              },
            ),
            position: LatLng(i.data['lattitude'], i.data['longitude'])));
      });
    }
  }

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
                    builder: (BuildContext context) => ExposedDialog(
                          data: i.data,
                          docId: i.documentID,
                        ));
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

  void createFacilitiesMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
            markerId: MarkerId(
                'Facilities ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Facilities Reported By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => FacilitiesDialog(
                          data: i.data,
                          docId: i.documentID,
                        ));
              },
            ),
            position: LatLng(i.data['lattitude'], i.data['longitude'])));
      });
    }
  }

  void createRequestsMarkers(List<DocumentSnapshot> markerData) {
    for (DocumentSnapshot i in markerData) {
      setState(() {
        allMarkers.add(Marker(
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            markerId: MarkerId(
                'Requests ${i.data['lattitude']} ${i.data['longitude']}'),
            infoWindow: InfoWindow(
              title: 'Requests By ${i.data['name']}',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => RequestsDialog(
                          data: i.data,
                          docId: i.documentID,
                        ));
              },
            ),
            position: LatLng(i.data['latitude'], i.data['longitude'])));
      });
    }
  }

  void createVolunteerMarkers(List<DocumentSnapshot> markerData) {}

  @override
  void initState() {
    initializeMarkers();
    super.initState();
  }

  void initializeMarkers() {
    var hazardStream = Firestore.instance.collection('hazards').getDocuments();
    var facilitiesStream =
        Firestore.instance.collection('facilities').getDocuments();
    var exposedStream =
        Firestore.instance.collection('exposed_elements').getDocuments();
    var damageStream = Firestore.instance.collection('damages').getDocuments();
    var waterLevel =
        Firestore.instance.collection('water_level').getDocuments();
    var requests = Firestore.instance.collection('requests').getDocuments();

    Future.wait([
      hazardStream,
      facilitiesStream,
      exposedStream,
      damageStream,
      waterLevel,
      requests
    ]).then((List<QuerySnapshot> responses) => {
          createHazardsMarkers(responses[0].documents),
          createFacilitiesMarkers(responses[1].documents),
          createExposedMarkers(responses[2].documents),
          createDamagedMarkers(responses[3].documents),
          createWaterMarkers(responses[4].documents),
          createRequestsMarkers(responses[5].documents)
        });
  }

  @override
  Widget build(BuildContext context) {
    var location =
        new Location(); //.changeSettings(accuracy: LocationAccuracy.BALANCED,interval: 120000);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Volunteer',
            style: TextStyle(color: activityColor),
          ),
          iconTheme: IconThemeData(color: activityColor),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actions: <Widget>[
            Switch(
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                value: active,
                onChanged: (val) => setState(() {
                      active = val;
                      active == true
                          ? activityColor = Colors.green
                          : activityColor = Colors.red;
                    })),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                initializeMarkers();
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: location.onLocationChanged(),
          builder: (BuildContext context,
              AsyncSnapshot<LocationData> locationSnapshot) {
            location.changeSettings(
                accuracy: LocationAccuracy.BALANCED, interval: 30000);
            home = CameraPosition(
                target: LatLng(locationSnapshot.data.latitude,
                    locationSnapshot.data.longitude),
                zoom: 14.4746);
            void updateLocation() {
              print("Updating Location...");

              Firestore.instance
                  .collection('volunteer')
                  .document('${widget.uid}')
                  .setData({
                'uid': widget.uid,
                'name': widget.uname,
                'latitude': locationSnapshot.data.latitude,
                'longitude': locationSnapshot.data.longitude,
                'distress': false,
                'phone': widget.phone,
                'updated_at': FieldValue.serverTimestamp(),
              });
            }

            if (active) {
              const oneMinute = const Duration(seconds: 60);
              timer = Timer.periodic(oneMinute, (Timer t) => updateLocation());
            } else if (timer != null) {
              timer.cancel();
            }
            return StreamBuilder(
              stream: Firestore.instance.collection('volunteer').snapshots(),
              builder: (context, snapshot) {
                for (DocumentSnapshot i in snapshot.data.documents) {
                  allMarkers.add(Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                      markerId: MarkerId(
                          'Volunteer ${i.data['latitude']} ${i.data['longitude']}'),
                      infoWindow: InfoWindow(
                        title: 'Volunteer ${i.data['name']}',
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  VolunteerDialog(data: i.data));
                        },
                      ),
                      position:
                          LatLng(i.data['latitude'], i.data['longitude'])));
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition: home,
                        compassEnabled: true,
                        myLocationEnabled: true,
                        markers: Set.from(allMarkers),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(0.0),
                      elevation: 12.0,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        height: 144,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 72,
                                        width: 72,
                                        child: !active
                                            ? SvgPicture.asset(
                                                'assets/svg/facilities.svg')
                                            : SvgPicture.asset(
                                                'assets/svg/facilities_active.svg')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Facilities',
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                final resultf = Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Facilities(
                                              uid: widget.uid,
                                              name: widget.uname,
                                              lattitude: locationSnapshot
                                                  .data.latitude,
                                              longitude: locationSnapshot
                                                  .data.longitude,
                                            )));
                                resultf.then((onValue) {
                                  initializeMarkers();
                                });
                              },
                            ),
                            RaisedButton(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 72,
                                        width: 72,
                                        child: !active
                                            ? SvgPicture.asset(
                                                'assets/svg/life_threat.svg')
                                            : SvgPicture.asset(
                                                'assets/svg/life_threat.svg')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Requests',
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                final resulth = Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => LifeThreat(
                                              uid: widget.uid,
                                              name: widget.uname,
                                              latitude: locationSnapshot
                                                  .data.latitude,
                                              longitude: locationSnapshot
                                                  .data.longitude,
                                            )));
                                resulth.then((blah) {
                                  initializeMarkers();
                                });
                              },
                            ),
                            RaisedButton(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 72,
                                        width: 72,
                                        child: !active
                                            ? SvgPicture.asset(
                                                'assets/svg/hazards.svg')
                                            : SvgPicture.asset(
                                                'assets/svg/hazard_active.svg')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Hazards',
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                final resulth = Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Hazards(
                                              uid: widget.uid,
                                              name: widget.uname,
                                              lattitude: locationSnapshot
                                                  .data.latitude,
                                              longitude: locationSnapshot
                                                  .data.longitude,
                                            )));
                                resulth.then((blah) {
                                  initializeMarkers();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ));
  }
}

class RequestsDialog extends StatelessWidget {
  final Map data;

  final String docId;
  RequestsDialog({this.data, this.docId});

  @override
  Widget build(BuildContext context) {
    print(data);
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
              'Requests',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              data['name'] + '\n\n' + data['description'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'requests',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'requests',
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text('GO BACK'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VolunteerDialog extends StatelessWidget {
  final Map data;
  VolunteerDialog({this.data});

  @override
  Widget build(BuildContext context) {
    print(data);
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
              'Volunteer',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              data['name'] + '\n\n' + data['phone'],
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

class HazardDialog extends StatelessWidget {
  final Map data;

  final String docId;
  HazardDialog({this.data, this.docId});

  @override
  Widget build(BuildContext context) {
    print(data);
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
              'Hazards',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reported by ' +
                  data['name'] +
                  '\n\n' +
                  'Typology: ' +
                  data['typology'] +
                  '\n' +
                  'Source of Hazard: ' +
                  data['source'] +
                  '\n'
                      'Material State: ' +
                  data['material_state'] +
                  '\n' +
                  'Material Type: ' +
                  data['material_typology'] +
                  '\n' +
                  'Spill State: ' +
                  (data['spill_state'] +
                      '\n' +
                      'Explosion Type: ' +
                      data['explosion_type']),
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'hazards',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'hazards',
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text('GO BACK'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilitiesDialog extends StatelessWidget {
  final Map data;
  final String docId;
  FacilitiesDialog({this.data, this.docId});

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
              'Facilities',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reported by ' +
                  data['name'] +
                  '\n\n' +
                  'Typology: \n' +
                  data['typology'] +
                  'Number: \n' +
                  data['number'] +
                  'Building Type: \n' +
                  data['building_type'] +
                  'Ground Type: \n' +
                  data['ground_type'] +
                  'Vehicle Type: \n' +
                  data['vehicle_type'],

              //data['file_name'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'facilities',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'facilities',
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text('GO BACK'),
                  ),
                ],
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
