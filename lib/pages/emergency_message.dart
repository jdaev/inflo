// EMERGENCY MESSAGE
// The tool “Emergency message” allows users:
// • to send a customizable emergency message along with current coordinates.
// • Fill-in a personalised emergency message
// • Send it automatically to the list of contact previously uploaded in the “personal plan” [see
// page 13]
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:location/location.dart';
import 'package:flushbar/flushbar.dart';

class EMessage extends StatefulWidget {
  final LocationData currentLocation;
  final List contacts;
  const EMessage({Key key, this.currentLocation, this.contacts})
      : super(key: key);
  @override
  _EMessageState createState() => _EMessageState();
}

class _EMessageState extends State<EMessage> {
  TextEditingController _messageController = new TextEditingController();

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

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
                  decoration: InputDecoration(labelText: 'Enter your Message'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'User\'s Coordinates',
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Text(widget.currentLocation.latitude.toString() +
                  '  ' +
                  widget.currentLocation.longitude.toString()),
              RaisedButton.icon(
                label: Text(
                  'Send',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                color: Colors.red,
                onPressed: () {
                  if (widget.contacts != null) {
                    print('yeet');
                    List<String> recipients = [];
                    Flushbar flushbar = new Flushbar(
                      isDismissible: false,
                      message:
                          'This will send the message to all your added contacts',
                      title: ('Sending...'),
                      showProgressIndicator: true,
                    );
                    flushbar.show(context);
                    for (var contact in widget.contacts) {
                      recipients.add(contact['phone'].toString());
                    }
                    FlutterSms.sendSMS(
                            message: _messageController.text + widget.currentLocation.latitude.toString() + widget.currentLocation.longitude.toString(),
                            recipients: recipients)
                        .then((onValue) {
                      flushbar.dismiss();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
