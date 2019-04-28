//... ON WATER LEVEL
//From this display users can provide information and pictures on water height from the ground.
//Users, in case of heavy rains and/or floods, can send to the competent authorities their
//estimates on the water height as well as a picture to contextualise the provided info.
//The picture image can be adjusted by clicking on the Gear ikon on the top left of the display
//(A)
//

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:inflo/pages/detect_location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WaterLevel extends StatefulWidget {
  final String userDocRef;
  final String uid;
  final Map userData;

  const WaterLevel({Key key, this.userDocRef, this.uid, this.userData})
      : super(key: key);

  @override
  _WaterLevelState createState() => _WaterLevelState();
}

TextEditingController waterLevel = new TextEditingController();

TextEditingController _locationController = new TextEditingController();
String lat = '';
String long = '';

class _WaterLevelState extends State<WaterLevel> {
  File _image;
  var location;
  Future getLocation(value) async {
    setState(() {
      location = value;
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromDevice() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _sourceChoice() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  getImageFromCamera().then((onValue) {
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Use Camera',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImageFromDevice().then((onValue) {
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'From Device',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        })) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Level'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  final result = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetectLocation()));

                  result.then((onValue) {
                    getLocation(onValue);
                    setState(() {
                      lat = onValue[0].toString();
                      long = onValue[1].toString();
                      _locationController = TextEditingController(
                          text: 'LAT:  ' + lat + '\n' + 'LONG: ' + long);
                    });
                  });
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    maxLines: 2,
                    controller: _locationController,
                    decoration: InputDecoration(hintText: 'Location'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: waterLevel,
                decoration: InputDecoration(
                    hintText: 'Enter Water Level', suffixText: ' CM'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.red,
                      colorBrightness: Brightness.dark,
                      child: Text('UPLOAD PHOTO'),
                      onPressed: () {
                        _sourceChoice();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      image: DecorationImage(
                          image: _image != null
                              ? FileImage(_image)
                              : AssetImage('assets/loading_cat.png'))),
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                color: Colors.red,
                colorBrightness: Brightness.dark,
                child: Text('SEND'),
                onPressed: () {
                  if (_image != null) {
                    final String fileName =
                        widget.uid + TimeOfDay.now().toString() + '.jpg';
                    final firebaseStorageRef =
                        FirebaseStorage.instance.ref().child(fileName);
                    final StorageUploadTask task =
                        firebaseStorageRef.putFile(_image);
                    task.onComplete.then((onValue) {
                      Firestore.instance.collection('water_level').add({
                        'uid': widget.uid,
                        'file_name': fileName,
                        'water_level': waterLevel.text,
                        'lattitude': location[0],
                        'longitude': location[1],
                        'name': widget.userData['name'],
                        'phone': widget.userData['phone']
                      }).then((onValue) {
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    Firestore.instance.collection('water_level').add({
                      'uid': widget.uid,
                      'water_level': waterLevel.text,
                      'lattitude': location[0],
                      'longitude': location[1],
                      'name': widget.userData['name'],
                      'phone': widget.userData['phone']
                    }).then((onValue) {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
