import 'package:flutter/material.dart';

class RequestForHelp extends StatefulWidget {
  @override
  _RequestForHelpState createState() => _RequestForHelpState();
}

class _RequestForHelpState extends State<RequestForHelp> {
  String _selectedDistrict;
  static const List<String> _keralaDistricts = <String>[
    'Alappuzha',
    'Ernakulam',
    'Idukki',
    'Kannur',
    'Kasaragod',
    'Kollam',
    'Kottayam',
    'Kozhikode',
    'Malappuram',
    'Palakkad',
    'Pathanamthitta',
    'Thiruvananthapuram',
    'Thrissur',
    'Wayanad'
  ];

  TextEditingController _locationTextController;

  List<DropdownMenuItem<String>> _dropDownMenuItems =
      new List<DropdownMenuItem<String>>();

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_keralaDistricts);
    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List districts) {
    List<DropdownMenuItem<String>> items = new List();
    for (String district in districts) {
      items.add(
          new DropdownMenuItem(value: district, child: new Text(district)));
    }
    return items;
  }

  void changedDropDownItem(String selectedDistrict) {
    setState(() {
      _selectedDistrict = selectedDistrict;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Request for Help'),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(
            hint: Text('District'),
            isExpanded: true,
            value: _selectedDistrict,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          TextFormField(
            controller: _locationTextController,
            decoration: InputDecoration(hintText: 'Location'),
          )
        ],
      ),
    );
  }

}
