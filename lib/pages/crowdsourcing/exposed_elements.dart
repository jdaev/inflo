//... ON PEOPLE
//From this display users can provide information on From where users can provide information
//and pictures on people involved in a risk/emergency situation.
//Information are collected on:
//• Number of people present in the risk/emergency situation
//• Their age (range)
//• Number of people with limited mobility
//• Number of elderly people in need of assistance
//Provided information is sent immediately to the competent authority by clicking on the send
//button
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:inflo/pages/detect_location.dart';

class ExposedElements extends StatefulWidget {
  final String userDocRef;
  final String uid;
  final Map userData;

  const ExposedElements({Key key, this.uid, this.userData, this.userDocRef})
      : super(key: key);
  @override
  _ExposedElementsState createState() => _ExposedElementsState();
}

class _ExposedElementsState extends State<ExposedElements> {
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _noOfResidentsController = new TextEditingController();
  TextEditingController _noWithLimitedMobilityController =
      new TextEditingController();
  TextEditingController _noOfElderlyController = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  var location;
  @override
  Widget build(BuildContext context) {
    Future getLocation(value) async {
      setState(() {
        location = value;
      });
    }

    String lage='';
    String uage='';
    String lat='';
    String long='';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Exposed Elements'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: SingleChildScrollView(
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
                  controller: _noOfResidentsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'No Of Residents'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text('Age'),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: RangeSlider(
                        lowerValue: 0,
                        upperValue: 100,
                        valueIndicatorMaxDecimals: 0,
                        
                        max: 100,
                        onChangeEnd: (lvalue, uvalue) {
                          lage = lvalue.toString();
                          uage = uvalue.toString();
                        },
                        onChanged: (lvalue, uvalue) {
                          lage = lvalue.toString();
                          uage = uvalue.toString();
                        },
                        divisions: 100,
                        showValueIndicator: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _noWithLimitedMobilityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: 'People With Limited Mobility'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _noOfElderlyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Elderly People'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _description,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.red,
                  colorBrightness: Brightness.dark,
                  child: Text('SUBMIT'),
                  onPressed: () {
                    Firestore.instance.collection('exposed_elements').add({
                      'uid': widget.uid,
                      'no_residents': _noOfResidentsController.text,
                      'no_elderly': _noOfElderlyController.text,
                      'no_ability': _noWithLimitedMobilityController.text,
                      'l_age': lage,
                      'u_age': uage,
                      'description': _description.text,
                      'lattitude': location[0],
                      'longitude': location[1],
                      'name': widget.userData['name'],
                      'phone': widget.userData['phone']
                    }).then((onValue) {
                      Navigator.pop(context);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
