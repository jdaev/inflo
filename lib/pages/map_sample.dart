import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

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
                print(i.documentID);
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
                print(i.documentID);

                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DamageDialog(data: i.data, docId: i.documentID));
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
                print(i.documentID);

                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        WaterDialog(data: i.data, docId: i.documentID));
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
    } else {
      setState(() {
        location = widget.location;
        home = CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 14.4746);
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
  final String docId;
  ExposedDialog({this.data, this.docId});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'exposed_elements',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'exposed_elements',
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

class DeleteButton extends StatefulWidget {
  final Map data;
  final String docId;
  final String collection;

  const DeleteButton({Key key, this.data, this.docId, this.collection})
      : super(key: key);
  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot user) {
          return StreamBuilder(
              stream: Firestore.instance
                  .collection(widget.collection)
                  .document(widget.docId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (user.data.uid == widget.data['uid']) {
                  return FlatButton(
                    child: Text('DELETE'),
                    onPressed: () {
                      Firestore.instance
                          .collection(widget.collection)
                          .document(widget.docId)
                          .delete();
                    },
                  );
                } else {
                  return Container();
                }
              });
        });
  }
}

class UpvoteButton extends StatefulWidget {
  final Map data;
  final String docId;
  final String collection;

  const UpvoteButton({Key key, this.data, this.docId, this.collection})
      : super(key: key);
  @override
  _UpvoteButtonState createState() => _UpvoteButtonState();
}

class _UpvoteButtonState extends State<UpvoteButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(widget.collection)
            .document(widget.docId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(snapshot.data.data);
            if (snapshot.data.data['liked_users']
                .contains(widget.data['uid'])) {
              return Row(
                children: <Widget>[
                  Text(snapshot.data.data['no_liked'].toString()),
                  InkWell(
                    onTap: () {
                      Firestore.instance
                          .collection(widget.collection)
                          .document(widget.docId)
                          .updateData({
                        'no_liked': widget.data['no_liked'] - 1,
                        'liked_users':
                            FieldValue.arrayRemove([widget.data['uid']])
                      }).then((onValue) {
                        setState(() {});
                      });
                    },
                    child: SizedBox(
                      width: 32,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Row(
                children: <Widget>[
                  Text(snapshot.data.data['no_liked'].toString()),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    onTap: () {
                      Firestore.instance
                          .collection(widget.collection)
                          .document(widget.docId)
                          .updateData({
                        'no_liked': widget.data['no_liked'] + 1,
                        'liked_users':
                            FieldValue.arrayUnion([widget.data['uid']])
                      }).then((onValue) {
                        setState(() {});
                      });
                    },
                  )
                ],
              );
            }
          } else
            return CircularProgressIndicator();
        });
  }
}

class DamageDialog extends StatelessWidget {
  final Map data;
  final String docId;
  DamageDialog({this.data, this.docId});

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
            data['file_name'] != null
                ? ImageLink(
                    imageLink: data['file_name'],
                  )
                : Text('No Image'),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'damages',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'damages',
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

class ImageLink extends StatefulWidget {
  final String imageLink;

  const ImageLink({Key key, this.imageLink}) : super(key: key);
  @override
  _ImageLinkState createState() => _ImageLinkState();
}

class _ImageLinkState extends State<ImageLink> {
  String url = 'No Image';

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(widget.imageLink);
    return FutureBuilder(
      future: ref.getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot link) {
        if (link.hasData) {
          return InkWell(
            child: Text(link.data),
            onTap: () {
              _launchURL(link.data);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class WaterDialog extends StatelessWidget {
  final Map data;
  final String docId;
  WaterDialog({this.data, this.docId});

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
            data['file_name'] != null
                ? ImageLink(
                    imageLink: data['file_name'],
                  )
                : Text('No Image'),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpvoteButton(
                    data: data,
                    docId: docId,
                    collection: 'water_level',
                  ),
                  DeleteButton(
                    data: data,
                    docId: docId,
                    collection: 'water_level',
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
