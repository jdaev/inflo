import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPages extends StatefulWidget {
  final Widget child;

  IntroPages({Key key, this.child}) : super(key: key);

  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final pages = [
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        body: Text(
          'Emergency & Hazard Reporting.',
        ),
        title: Container(),
        mainImage: Image.asset(
          'assets/logo.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      body: Text(
        'Real Time Maps & Chat',
      ),
      title: Text(''),
      mainImage: Image.asset(
        'assets/loading_cat.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      body: Text(
        'Flood Preparedness Kit ',
      ),
      title: Text(''),
      mainImage: Image.asset(
        'assets/loading_cat.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ThemeData
      body: Builder(
        builder: (context) => IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                SharedPreferences.getInstance().then((onValue){
                  onValue.setBool('introShown', true);
                  Navigator.pop(context);
                });
              },
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}
