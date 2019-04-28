import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Facilities extends StatefulWidget {
  final String uid;
  final double lattitude;
  final double longitude;
  final String name;
  const Facilities({Key key, this.uid, this.lattitude, this.longitude, this.name}) : super(key: key);
  @override
  _FacilitiesState createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  int typologyRadioValue = -1;
  int typeBuildingRadioValue = -1;
  int typeGroundRadioValue = -1;
  int typeVehicleRadioValue = -1;
  String typology='', number='', type='', typeGround='', typeVehicle='';

  void _handleTypologyRadioValueChange(int value) {
    setState(() {
      typologyRadioValue = value;

      switch (typologyRadioValue) {
        case 0:
          setState(() {
            typology = 'Building';
          });
          break;
        case 1:
          setState(() {
            typology = 'Infrastucture';
          });
          break;
        case 2:
          setState(() {
            typology = 'Vehicle';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleTypeBuildingRadioValueChange(int value) {
    setState(() {
      typeBuildingRadioValue = value;

      switch (typeBuildingRadioValue) {
        case 0:
          setState(() {
            type = 'Public Office';
          });
          break;
        case 1:
          setState(() {
            type = 'Single House';
          });
          break;
        case 2:
          setState(() {
            type = 'Apartment';
          });
          break;
        case 3:
          setState(() {
            type = 'Commercial Center';
          });
          break;
        case 4:
          setState(() {
            type = 'Bridge';
          });
          break;
        case 5:
          setState(() {
            type = 'Warehouse';
          });
          break;
        case 6:
          setState(() {
            type = 'Road Tunnel';
          });
          break;
        case 7:
          setState(() {
            type = 'School';
          });
          break;
        case 8:
          setState(() {
            type = 'Airport';
          });
          break;
        case 9:
          setState(() {
            type = 'Public Transport';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handletypeGroundRadioValueChange(int value) {
    setState(() {
      typeGroundRadioValue = value;

      switch (typeGroundRadioValue) {
        case 0:
          setState(() {
            typeGround = 'Landslide Risk';
          });
          break;
        case 1:
          setState(() {
            typeGround = 'Flood Risk';
          });
          break;
        case 2:
          setState(() {
            typeGround = 'No Risk';
          });
          break;

        default:
          break;
      }
    });
  }

  void _handletypeVehicleRadioValueChange(int value) {
    setState(() {
      typeVehicleRadioValue = value;

      switch (typeVehicleRadioValue) {
        case 0:
          setState(() {
            typeVehicle = 'Car';
          });
          break;
        case 1:
          setState(() {
            typeVehicle = 'Two-Wheeler';
          });
          break;
        case 2:
          setState(() {
            typeVehicle = 'Bus';
          });
          break;
        case 3:
          setState(() {
            typeVehicle = 'Truck';
          });
          break;
        case 4:
          setState(() {
            typeVehicle = 'Auto';
          });
          break;
        case 5:
          setState(() {
            typeVehicle = 'Boat';
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
        title: Text('Facilities'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "What Facilities are there ?",
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          Text('Type Of Facility'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 0,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Building'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 1,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Infrasructure'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 2,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Vehicle'),
                ),
              ],
            ),
          ),
          Text('Number Of Buildings'),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    number = val.toString();
                  });
                },
              )),
          Text('Type Of Buildings'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 0,
                  title: Text('Public Office'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 1,
                  title: Text('Single House'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 2,
                  title: Text('Apartment'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 3,
                  title: Text('Commercial Center'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 4,
                  title: Text('Bridge'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 5,
                  title: Text('Warehouse'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 6,
                  title: Text('Road Tunnel'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 7,
                  title: Text('School'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 8,
                  title: Text('Airport'),
                ),
                RadioListTile(
                  groupValue: typeBuildingRadioValue,
                  onChanged: _handleTypeBuildingRadioValueChange,
                  value: 9,
                  title: Text('Public Transport'),
                ),
              ],
            ),
          ),
          Text('Ground Risk'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typeGroundRadioValue,
                  onChanged: _handletypeGroundRadioValueChange,
                  value: 0,
                  title: Text('Landslide Risk'),
                ),
                RadioListTile(
                  groupValue: typeGroundRadioValue,
                  onChanged: _handletypeGroundRadioValueChange,
                  value: 1,
                  title: Text('Flood Risk'),
                ),
                RadioListTile(
                  groupValue: typeGroundRadioValue,
                  onChanged: _handletypeGroundRadioValueChange,
                  value: 2,
                  title: Text('No Risk'),
                ),
                RadioListTile(
                  groupValue: typeGroundRadioValue,
                  onChanged: _handletypeGroundRadioValueChange,
                  value: 3,
                  title: Text('Unknown'),
                ),
              ],
            ),
          ),
          Text('Vehicle Type'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 0,
                  title: Text('Car'),
                ),
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 1,
                  title: Text('Two-Wheeler'),
                ),
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 3,
                  title: Text('Bus'),
                ),
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 4,
                  title: Text('Truck'),
                ),
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 5,
                  title: Text('Auto'),
                ),
                RadioListTile(
                  groupValue: typeVehicleRadioValue,
                  onChanged: _handletypeVehicleRadioValueChange,
                  value: 6,
                  title: Text('Boat'),
                ),
              ],
            ),
          ),
          Center(
            child: RaisedButton(
              child: Text('SUBMIT'),
              color: Colors.red,
              onPressed: () {
                Firestore.instance.collection('facilities').add({
                  'uid': widget.uid,
                  'typology': typology,
                  'number': number,
                  'building_type': type,
                  'ground_type': typeGround,
                  'vehicle_type': typeVehicle,
                  'name':widget.name,
                  'lattitude':widget.lattitude,
                  'longitude':widget.longitude
                }).then((val) {
                  Navigator.pop(context,[true]);
                });
              },
              colorBrightness: Brightness.dark,
            ),
          )
        ],
      ),
    );
  }
}
