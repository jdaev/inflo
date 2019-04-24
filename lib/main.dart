import 'package:flutter/material.dart';
import 'package:inflo/login/login_screen.dart';
import 'package:inflo/pages/crowdsourcing/damages.dart';
import 'package:inflo/pages/crowdsourcing/exposed_elements.dart';
import 'package:inflo/pages/crowdsourcing/participation.dart';
import 'package:inflo/pages/crowdsourcing/water_level.dart';
import 'pages/emergency_message.dart';
import 'pages/emergency_toolkit.dart';

void main() => runApp(MyApp());
const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LogIn(),
      routes: <String, WidgetBuilder>{
        //'/request_for_help': (BuildContext context) => RequestForHelp(),
        '/emergency_message': (BuildContext context) => EMessage(),
        '/participation': (BuildContext context) => Participation(),
        '/exposed_elements': (BuildContext context) => ExposedElements(),
        '/damages': (BuildContext context) => Damages(),
        '/water_level': (BuildContext context) => WaterLevel(),
      },
    );
  }
}
