import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inflo/landing.dart';
import 'package:multi_page_form/multi_page_form.dart';

class SignUpScreen extends StatefulWidget {
  final Widget child;

  SignUpScreen({Key key, this.child}) : super(key: key);

  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _pinController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

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
    //_selectedDistrict = _dropDownMenuItems[0].value;
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
        title: Text('Sign Up'),
        //backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: MultiPageForm(
          totalPage: 3,
          pageList: <Widget>[page1(), page4(), page3()],
          onFormSubmitted: () {
            FirebaseAuth.instance.currentUser().then((user) {
              Firestore.instance.collection('users').add({
                'name': _nameController.text,
                'uid': user.uid,
                'phone': _phoneController.text,
                'pin': _pinController.text,
                'district': _selectedDistrict,
                'email': _emailController.text,
                'dob': _selectedDate,
              }).then((onValue) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LandingPage(userName: _nameController.text,uid: user.uid,)),
                );
              }).catchError((onError) {
                print(onError);
              });
            });
          }),
    );
  }

  Widget page1() {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(36, 36, 36, 4),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'What\'s your name?',
          ),
          controller: _nameController,
        ),
      ),
    ));
  }

  Widget page2() {
    return Container();
  }

  Widget page3() {
    return Container(
        child: Center(
      child: Text('You\'re all done, let\'s start learning!'),
    ));
  }

  Widget page4() {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 36, 36, 4),
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
    ));
  }
}
