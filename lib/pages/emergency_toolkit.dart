//EMERGENCY TOOLKIT
//The Emergency toolkit groups together some useful tools, turning the user’s mobile phone
//into an emergency device:
//• an acoustic alarm
//• a strobe light (if available on the user’s phone)
//• and a flashlight.
//
import 'package:flutter/material.dart';

class EToolkit extends StatefulWidget {
  @override
  _EToolkitState createState() => _EToolkitState();
}

class _EToolkitState extends State<EToolkit> {
  bool _alarmStatus = false;
  bool _strobeStatus = false;
  bool _torchStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Toolkit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Alarm'),
                ),
                Switch(
                  onChanged: (value) => setState(() {
                        _alarmStatus = value;
                      }),
                  value: _alarmStatus,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Strobe Light'),
                ),
                Switch(
                  onChanged: (value) => setState(() {
                        _strobeStatus = value;
                      }),
                  value: _strobeStatus,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Torch'),
                ),
                Switch(
                  onChanged: (value) => setState(() {
                        _torchStatus = value;
                      }),
                  value: _torchStatus,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
