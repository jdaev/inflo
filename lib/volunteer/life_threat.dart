import 'package:inflo/toggle_button.dart';
import 'package:flutter/material.dart';

class LifeThreat extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life Threats'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text('data')
        ],
      ),
      
    );
  }
}