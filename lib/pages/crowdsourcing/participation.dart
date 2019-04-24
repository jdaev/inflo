//START REPORTING
//From this display users car register to actively contribute in case of emergency reporting on
//events, hazards and dangers.
//Users have to fill in the form by providing:
//• Name
//• Surname
//• Telephone Number
//In order to register users have to first agree with the Privacy Terms and Conditions to which
//they can access by clicking on the orange link [see page 13].
//
import 'package:flutter/material.dart';

class Participation extends StatelessWidget {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participation'),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(hintText: 'Phone'),
          ),
          Text('Privacy Terms and Conditons'),
          FlatButton(
            child: Text('AGREE & CONTINUE'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
