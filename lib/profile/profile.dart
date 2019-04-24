import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String selDistrict;

class ProfileScreen extends StatefulWidget {
  final Widget child;
  final String userId;
  final String userDocumentPath;
  ProfileScreen(
      {Key key,
      this.child,
      this.userId,
      this.userDocumentPath})
      : super(key: key);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    Future<bool> textDialog(
        BuildContext context, String title, String category) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String newVal;
            return new AlertDialog(
              title: Text(title),
              content: TextField(
                onChanged: (value) => {newVal = value},
              ),
              contentPadding: EdgeInsets.all(10.0),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    if (newVal != null) {
                      Firestore.instance
                          .collection('users')
                          .document(widget.userDocumentPath)
                          .updateData({category: newVal}).then((onValue) {
                        setState(() {});
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            );
          });
    }

    Future<bool> districtDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('Select your District'),
              content: DistrictDialogContent(),
              contentPadding: EdgeInsets.all(10.0),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    if (selDistrict != null) {
                      Firestore.instance
                          .collection('users')
                          .document(widget.userDocumentPath)
                          .updateData({'district': selDistrict}).then(
                              (onValue) {
                        setState(() {});
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            );
          });
    }

    DateTime _selectedDate = DateTime.now();
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1984, 1),
          lastDate: DateTime(2101));
      if (picked != null && picked != _selectedDate)
        setState(() {
          _selectedDate = picked;
          Firestore.instance
              .collection('users')
              .document(widget.userDocumentPath)
              .updateData({'dob': _selectedDate});
        });
    }

    return FutureBuilder(
      future: Firestore.instance.collection('users').document(widget.userDocumentPath).get(),
      builder: (BuildContext context, AsyncSnapshot user) {
        if (user.hasData) {
          print(user.data);
          Widget _profileHeader() {
            return SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: devicePadding.top,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    user.data['name'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider()
              ]),
            );
          }

          Widget _detailEditor(TextEditingController controller, IconData icon,
              String category) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(icon), border: InputBorder.none),
                      controller: controller,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    switch (category) {
                      case 'phone':
                        textDialog(
                            context, 'Enter your new Phone Number', category);
                        break;
                      case 'email':
                        textDialog(context, 'Enter your new Email', category);
                        break;
                      case 'name':
                        textDialog(context, 'Enter your new Name', category);
                        break;
                      case 'dob':
                        _selectDate(context);
                        break;
                      case 'pin':
                        textDialog(context, 'Enter your new Pincode', category);
                        break;
                      case 'district':
                        districtDialog(context);
                        break;

                      default:
                    }
                  },
                ),
              ],
            );
          }

          Widget _profileDetails() {
            TextEditingController _phoneController =
                new TextEditingController(text: user.data['phone']);
            TextEditingController _emailController =
                new TextEditingController(text: user.data['email']);
            TextEditingController _nameController =
                new TextEditingController(text: user.data['name']);
            TextEditingController _dobController =
                new TextEditingController(text: user.data['dob'].toString());
            TextEditingController _pinController =
                new TextEditingController(text: user.data['pin']);
            TextEditingController _districtController =
                new TextEditingController(text: user.data['district']);
            return SliverList(
              delegate: SliverChildListDelegate([
                Divider(),
                Text('Contact Details'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _detailEditor(_phoneController, Icons.phone, 'phone'),
                      _detailEditor(_emailController, Icons.email, 'email'),
                    ],
                  ),
                ),
                Divider(),
                Text('Personal Information'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _detailEditor(_nameController, Icons.person, 'name'),
                      _detailEditor(
                          _dobController, Icons.calendar_today, 'dob'),
                      _detailEditor(
                          _districtController, Icons.location_city, 'district'),
                      _detailEditor(_pinController, Icons.pin_drop, 'pin'),
                    ],
                  ),
                ),
              ]),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: new CustomScrollView(
              slivers: <Widget>[
                _profileHeader(),
                _profileDetails(),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class DistrictDialogContent extends StatefulWidget {
  @override
  _DistrictDialogContentState createState() => _DistrictDialogContentState();
}

class _DistrictDialogContentState extends State<DistrictDialogContent> {
  final List<String> _keralaDistricts = <String>[
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
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedDistrict;
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List districts) {
    List<DropdownMenuItem<String>> items = new List();
    for (String district in districts) {
      items.add(
          new DropdownMenuItem(value: district, child: new Text(district)));
    }
    return items;
  }

  void changedDropDownItem(String selectedDistrict) {
    _selectedDistrict = selectedDistrict;
    selDistrict = _selectedDistrict;
  }

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_keralaDistricts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
        hint: Text('District'),
        isExpanded: true,
        value: _selectedDistrict,
        items: _dropDownMenuItems,
        onChanged: changedDropDownItem,
      ),
    );
  }
}
