//... ON INFRASTRUCTURES
//From this display users can provide information on infrastructure and facilities involved in a
//risk/emergency situation.
//• Users can provide relevant information on:
//• Whether or not they are in the infrastructure/building involved
//• The type of infrastructural damage
//• People present in the infrastructure/building involved
//Users can provide both information and pictures and send them to the competent authorities
//by clicking on the Send button.
//The picture image can be adjusted by clicking on the Gear ikon on the top left of the display
//(A)
//
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inflo/pages/detect_location.dart';

List<String> damageTypes = [
  'Gas Supplies',
  'Electricity Supplies',
  'Flooded Rooms',
  'Wastewater',
  'Fire',
  'Pipeline',
  'Wild Animals',
  'Flooded Road',
  'Collapsed Bridge',
  'Other'
];

class Damages extends StatefulWidget {
  final String userDocRef;
  final String uid;
  final Map userData;

  const Damages({Key key, this.userDocRef, this.uid, this.userData})
      : super(key: key);
  @override
  _DamagesState createState() => _DamagesState();
}

class _DamagesState extends State<Damages> {
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

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentDamage;
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String damage in damageTypes) {
      items.add(new DropdownMenuItem(value: damage, child: new Text(damage)));
    }
    return items;
  }

  TextEditingController _locationController = new TextEditingController();
  TextEditingController _noInvolved = new TextEditingController();
  String lat = '';
  String long = '';
  String viewType;
  int radioValue = -1;
  void _handleRadioValueChange(int value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          setState(() {
            viewType = 'Inside';
          });
          break;
        case 1:
          setState(() {
            viewType = 'outside';
          });
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Damages'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text(
                'Type of View',
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text('Inside'),
                ),
                Radio(
                  groupValue: radioValue,
                  value: 0,
                  onChanged: (val) => _handleRadioValueChange(val),
                )
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text('Outside'),
                ),
                Radio(
                  groupValue: radioValue,
                  value: 1,
                  onChanged: (val) => _handleRadioValueChange(val),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: _currentDamage,
                isExpanded: true,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
                hint: Text('Type Of Damage'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'No. Of People Involved'),
                keyboardType: TextInputType.number,
                controller: _noInvolved,
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
                            : AssetImage('assets/loading_cat.png')),
                  ),
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
                      Firestore.instance.collection('damages').add({
                        'uid': widget.uid,
                        'file_name': fileName,
                        'view_type': viewType,
                        'damage_type': _currentDamage,
                        'no_involved': _noInvolved.text,
                        'lattitude': location[0],
                        'longitude': location[1],
                        'name': widget.userData['name'],
                        'phone': widget.userData['phone'],
                        'no_liked': 0,
                        'liked_users': [widget.uid]
                      }).then((val) {
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    Firestore.instance.collection('damages').add({
                      'uid': widget.uid,
                      'view_type': viewType,
                      'damage_type': _currentDamage,
                      'no_involved': _noInvolved.text,
                      'lattitude': location[0],
                      'longitude': location[1],
                      'name': widget.userData['name'],
                      'phone': widget.userData['phone'],
                      'no_liked': 0,
                      'liked_users': [widget.uid]
                    }).then((val) {
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

  void changedDropDownItem(String selectedDamage) {
    setState(() {
      _currentDamage = selectedDamage;
    });
  }
}
