// EMERGENCY MESSAGE
// The tool “Emergency message” allows users:
// • to send a customizable emergency message along with current coordinates.
// • Fill-in a personalised emergency message
// • Send it automatically to the list of contact previously uploaded in the “personal plan” [see
// page 13]
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class EMessage extends StatefulWidget {
  final LocationData currentLocation;

  const EMessage({Key key, this.currentLocation}) : super(key: key);
  @override
  _EMessageState createState() => _EMessageState();
}

class _EMessageState extends State<EMessage> {
  TextEditingController _messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Message'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Enter your Message'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('User\'s Coordinates',style: Theme.of(context).textTheme.subhead,),
              ),
              Text(widget.currentLocation.latitude.toString() +
                  '  ' +
                  widget.currentLocation.longitude.toString()),
              RaisedButton.icon(
                label: Text('Send',style: TextStyle(color: Colors.white),),
                icon: Icon(Icons.email,color: Colors.white,),
                color: Colors.red,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
