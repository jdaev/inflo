import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hazards extends StatefulWidget {
  final String uid;
  final double lattitude;
  final double longitude;
  final String name;
  const Hazards({Key key, this.uid, this.lattitude, this.longitude, this.name})
      : super(key: key);
  @override
  _HazardsState createState() => _HazardsState();
}

class _HazardsState extends State<Hazards> {
  int typologyRadioValue = -1;
  int sourceRadioValue = -1;
  int typeRadioValue = -1;
  int materialStateRadioValue = -1;
  int materialTypologyRadioValue = -1;
  int spillStateRadioValue = -1;
  int oilLevelRadioValue = -1;
  int explosionTypeRadioValue = -1;
  String typology = '',
      source = '',
      type = '',
      materialState = '',
      materialTypology = '',
      spillState = '',
      oilLevel = '',
      explosionType = '';

  void _handleTypologyRadioValueChange(int value) {
    setState(() {
      typologyRadioValue = value;

      switch (typologyRadioValue) {
        case 0:
          setState(() {
            typology = 'Traffic Accident';
          });
          break;
        case 1:
          setState(() {
            typology = 'Oil Spill';
          });
          break;
        case 2:
          setState(() {
            typology = 'Electricity Line Damage';
          });
          break;
        case 3:
          setState(() {
            typology = 'Infrastructure Collapse';
          });
          break;
        case 4:
          setState(() {
            typology = 'Fire';
          });
          break;
        case 5:
          setState(() {
            typology = 'Wild Animals';
          });
          break;
        case 6:
          setState(() {
            typology = 'Flood';
          });
          break;
        case 7:
          setState(() {
            typology = 'Landslide';
          });
          break;
        case 8:
          setState(() {
            typology = 'Biohazard';
          });
          break;
        case 9:
          setState(() {
            typology = 'Unknown';
          });
          break;
        case 10:
          setState(() {
            typology = 'Other';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleSourceRadioValueChange(int value) {
    setState(() {
      sourceRadioValue = value;

      switch (sourceRadioValue) {
        case 0:
          setState(() {
            source = 'Oil';
          });
          break;
        case 1:
          setState(() {
            source = 'Trash';
          });
          break;
        case 2:
          setState(() {
            source = 'Flammable Materials';
          });
          break;
        case 3:
          setState(() {
            source = 'Gas';
          });
          break;
        case 4:
          setState(() {
            source = 'Storage Facility';
          });
          break;
        case 5:
          setState(() {
            source = 'Industrial Process';
          });
          break;
        case 6:
          setState(() {
            source = 'Human Violence';
          });
          break;
        case 7:
          setState(() {
            source = 'Water Level';
          });
          break;
        case 8:
          setState(() {
            source = 'Other';
          });
          break;
        case 9:
          setState(() {
            source = 'Unknown';
          });
          break;

        default:
          break;
      }
    });
  }

  void _handleTypeRadioValueChange(int value) {
    setState(() {
      typeRadioValue = value;

      switch (typeRadioValue) {
        case 0:
          setState(() {
            type = 'Accident';
          });
          break;
        case 1:
          setState(() {
            type = 'Collision';
          });
          break;
        case 2:
          setState(() {
            type = 'Leakage';
          });
          break;
        case 3:
          setState(() {
            type = 'Explosion';
          });
          break;
        case 4:
          setState(() {
            type = 'Collapse';
          });
          break;
        case 5:
          setState(() {
            type = 'Unknown';
          });
          break;
        case 6:
          setState(() {
            type = 'Other';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleMaterialStateRadioValueChange(int value) {
    setState(() {
      materialStateRadioValue = value;

      switch (materialStateRadioValue) {
        case 0:
          setState(() {
            materialState = 'Gas';
          });
          break;
        case 1:
          setState(() {
            materialState = 'Liquid';
          });
          break;
        case 2:
          setState(() {
            materialState = 'Solid';
          });
          break;
        case 3:
          setState(() {
            materialState = 'Unknown';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleMaterialTypologyRadioValueChange(int value) {
    setState(() {
      materialTypologyRadioValue = value;

      switch (materialTypologyRadioValue) {
        case 0:
          setState(() {
            materialTypology = 'Toxic';
          });
          break;
        case 1:
          setState(() {
            materialTypology = 'Non-Toxic';
          });
          break;
        case 2:
          setState(() {
            materialTypology = 'Unknown';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleSplillStateRadioValueChange(int value) {
    setState(() {
      spillStateRadioValue = value;

      switch (spillStateRadioValue) {
        case 0:
          setState(() {
            spillState = 'Ongoing spill';
          });
          break;
        case 1:
          setState(() {
            spillState = 'Risk of spill';
          });
          break;
        default:
          break;
      }
    });
  }

  void _handleExplosionTypeRadioValueChange(int value) {
    setState(() {
      explosionTypeRadioValue = value;

      switch (explosionTypeRadioValue) {
        case 0:
          setState(() {
            explosionType = 'Small';
          });
          break;
        case 1:
          setState(() {
            explosionType = 'Large';
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
        title: Text('Hazards'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "What hazards are there ?",
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          Text('Type'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 0,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Traffic Accident'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 1,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Oil Spill'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 2,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Electricity Line Damage'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 3,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Infrastructure Collapse'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 4,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Fire'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 5,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Wild Animals'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 6,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Flood'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 7,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Landslide'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 8,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Biohazard'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 9,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Unknown'),
                ),
                RadioListTile(
                  groupValue: typologyRadioValue,
                  value: 10,
                  onChanged: _handleTypologyRadioValueChange,
                  title: Text('Other'),
                ),
              ],
            ),
          ),
          Text('Sources Of Hazard'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 0,
                  title: Text('Oil'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 1,
                  title: Text('Trash'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 2,
                  title: Text('Flammable Materials'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 3,
                  title: Text('Gas'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 4,
                  title: Text('Storage Facility'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 5,
                  title: Text('Industrial Process'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 6,
                  title: Text('Human Violence'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 7,
                  title: Text('Water Level'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 8,
                  title: Text('Other'),
                ),
                RadioListTile(
                  groupValue: sourceRadioValue,
                  onChanged: _handleSourceRadioValueChange,
                  value: 9,
                  title: Text('Unknown'),
                ),
              ],
            ),
          ),
          Text('Type Of Accident'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 0,
                  title: Text('Accident'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 1,
                  title: Text('Collision'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 2,
                  title: Text('Leakage'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 3,
                  title: Text('Explosion'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 4,
                  title: Text('Collapse'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 5,
                  title: Text('Unknown'),
                ),
                RadioListTile(
                  groupValue: typeRadioValue,
                  onChanged: _handleTypeRadioValueChange,
                  value: 6,
                  title: Text('Other'),
                ),
              ],
            ),
          ),
          Text('Material State'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: materialStateRadioValue,
                  onChanged: _handleMaterialStateRadioValueChange,
                  value: 0,
                  title: Text('Gas'),
                ),
                RadioListTile(
                  groupValue: materialStateRadioValue,
                  onChanged: _handleMaterialStateRadioValueChange,
                  value: 1,
                  title: Text('Liquid'),
                ),
                RadioListTile(
                  groupValue: materialStateRadioValue,
                  onChanged: _handleMaterialStateRadioValueChange,
                  value: 2,
                  title: Text('Solid'),
                ),
                RadioListTile(
                  groupValue: materialStateRadioValue,
                  onChanged: _handleMaterialStateRadioValueChange,
                  value: 3,
                  title: Text('Unknown'),
                ),
              ],
            ),
          ),
          Text('Material Type'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: materialTypologyRadioValue,
                  onChanged: _handleMaterialTypologyRadioValueChange,
                  value: 0,
                  title: Text('Toxic'),
                ),
                RadioListTile(
                  groupValue: materialTypologyRadioValue,
                  onChanged: _handleMaterialTypologyRadioValueChange,
                  value: 1,
                  title: Text('Non-Toxic'),
                ),
                RadioListTile(
                  groupValue: materialTypologyRadioValue,
                  onChanged: _handleMaterialTypologyRadioValueChange,
                  value: 2,
                  title: Text('Unknown'),
                ),
              ],
            ),
          ),
          Text('Spill State'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: spillStateRadioValue,
                  value: 0,
                  onChanged: _handleSplillStateRadioValueChange,
                  title: Text('Ongoing Spill'),
                ),
                RadioListTile(
                  groupValue: spillStateRadioValue,
                  value: 1,
                  onChanged: _handleSplillStateRadioValueChange,
                  title: Text('Risk Of Spill'),
                ),
              ],
            ),
          ),
          Text('Explosion Type'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  groupValue: explosionTypeRadioValue,
                  value: 0,
                  onChanged: _handleExplosionTypeRadioValueChange,
                  title: Text('Small'),
                ),
                RadioListTile(
                  groupValue: explosionTypeRadioValue,
                  value: 1,
                  onChanged: _handleExplosionTypeRadioValueChange,
                  title: Text('Large'),
                ),
              ],
            ),
          ),
          Center(
            child: RaisedButton(
              child: Text('SUBMIT'),
              color: Colors.red,
              onPressed: () {
                Firestore.instance.collection('hazards').add({
                  'uid': widget.uid,
                  'typology': typology,
                  'source': source,
                  'type': type,
                  'material_state': materialState,
                  'material_typology': materialTypology,
                  'spill_state': spillState,
                  'explosion_type': explosionType,
                  'name': widget.name,
                  'lattitude': widget.lattitude,
                  'longitude': widget.longitude,
                  'no_liked': 0,
                      'liked_users': [widget.uid]
                }).then((val) {
                  Navigator.pop(context, [true]);
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
