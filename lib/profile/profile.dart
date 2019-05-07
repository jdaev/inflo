import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String selDistrict;

class ProfileScreen extends StatefulWidget {
  final Widget child;
  final String userId;
  final String userDocumentPath;
  ProfileScreen({Key key, this.child, this.userId, this.userDocumentPath})
      : super(key: key);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userDocumentReference;

  @override
  void initState() {
    super.initState();

    setState(() {
      userDocumentReference = widget.userDocumentPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle h2 = TextStyle(
      color: Colors.black.withOpacity(Colors.black.opacity * 0.84),
      fontSize: 18.0,
      height: 1,
      fontFamily: "Rubik",
    );
    TextStyle h1 = TextStyle(
        color: Colors.black.withOpacity(Colors.black.opacity * 0.84),
        fontSize: 28.0,
        height: 1,
        fontFamily: "Rubik",
        fontWeight: FontWeight.w600);
    TextStyle category = TextStyle(
      color: Colors.black.withOpacity(Colors.black.opacity * 0.84),
      fontSize: 12.0,
      height: 1,
      fontFamily: "Rubik",
    );

    return FutureBuilder(
      future: Firestore.instance
          .collection('users')
          .document(userDocumentReference)
          .get(),
      builder: (BuildContext context, AsyncSnapshot user) {
        if (user.hasData) {
          print(user.data);
          Widget _profileHeader() {
            return SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                                              child: Text(
                          user.data['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      district: user.data['district'],
                                      dob: user.data['dob'],
                                      email: user.data['email'],
                                      name: user.data['name'],
                                      phone: user.data['phone'],
                                      pin: user.data['pin'],
                                      uid: widget.userId,
                                      userDocRef: userDocumentReference,
                                    )),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                      )
                    ],
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
              ],
            );
          }

          Widget _profileDetails() {
            DateTime date = (user.data['dob']).toDate();
            print(date);
            TextEditingController _phoneController =
                new TextEditingController(text: user.data['phone']);
            TextEditingController _emailController =
                new TextEditingController(text: user.data['email']);
            TextEditingController _nameController =
                new TextEditingController(text: user.data['name']);
            TextEditingController _dobController = new TextEditingController(
                text: date.day.toString() +
                    ' / ' +
                    date.month.toString() +
                    ' / ' +
                    date.year.toString());
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
          return LinearProgressIndicator();
          
        }
      },
    );
  }
}

class EditProfile extends StatefulWidget {
  final String name;
  final DateTime dob;
  final String pin;
  final String district;
  final String phone;
  final String email;
  final String userDocRef;
  final String uid;

  const EditProfile(
      {Key key,
      this.name,
      this.dob,
      this.pin,
      this.district,
      this.phone,
      this.email,
      this.userDocRef,
      this.uid})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedDistrict;
  String userDocumentReference;
  String uid;
  DateTime dob;
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _pinController;
  TextEditingController _emailController;
  TextEditingController _dateController;

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
        _dateController.text = _selectedDate.day.toString() +
            ' / ' +
            _selectedDate.month.toString() +
            ' / ' +
            _selectedDate.year.toString();
      });
  }

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_keralaDistricts);
    _selectedDistrict = widget.district != null ? widget.district : null;
    _nameController = new TextEditingController(text: widget.name);
    _pinController = new TextEditingController(text: widget.pin);
    _phoneController = new TextEditingController(text: widget.phone);
    _emailController = new TextEditingController(text: widget.email);
    _dateController =
        new TextEditingController(text: widget.dob.toIso8601String());

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
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 36, 36, 4),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'What\'s your name?',
                        ),
                        controller: _nameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                              ),
                              controller: _dateController,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('District'),
                          isExpanded: true,
                          value: _selectedDistrict,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'PIN Code',
                        ),
                        controller: _pinController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        controller: _phoneController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-Mail',
                        ),
                        controller: _emailController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('SUBMIT'),
                  onPressed: () {
                    Firestore.instance
                        .collection('users')
                        .document(widget.userDocRef)
                        .updateData({
                      'name': _nameController.text,
                      'uid': widget.uid,
                      'phone': _phoneController.text,
                      'pin': _pinController.text,
                      'district': _selectedDistrict,
                      'email': _emailController.text,
                      'dob': _selectedDate,
                    }).then((onValue) {
                      Navigator.pop(context);
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
