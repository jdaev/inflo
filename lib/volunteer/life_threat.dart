import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inflo/toggle_button.dart';
import 'package:flutter/material.dart';

class LifeThreat extends StatelessWidget {
  final String uid;
  final String name;
  final double latitude;
  final double longitude;
  const LifeThreat(
      {Key key, this.uid, this.name, this.latitude, this.longitude})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController req = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text('Requests'),
          TextFormField(
            controller: req,
            maxLines: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.red,
              colorBrightness: Brightness.dark,
              child: Text('SUBMIT'),
              onPressed: () {
                Firestore.instance.collection('requests').add({
                  'uid': uid,
                  'description': req.text,
                  'latitude': latitude,
                  'longitude': longitude,
                  'name': name,
                  'no_liked': 1,
                  'liked_users': [uid]
                }).then((onValue) {
                  Navigator.pop(context);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
