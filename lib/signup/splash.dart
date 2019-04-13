import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final Widget child;
  
  Splash({Key key, this.child}) : super(key: key);

  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            SizedBox(
                width: 128,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.red),
                )),
          ],
        ),
      ),
    ),
    );
  }
}
