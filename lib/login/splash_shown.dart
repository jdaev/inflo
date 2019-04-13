import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final Widget child;

  Splash({Key key, this.child}) : super(key: key);

  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: widget.child,
    );
  }
}