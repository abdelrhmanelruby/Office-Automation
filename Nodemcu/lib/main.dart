import 'package:flutter/material.dart';
import 'package:nodemcu/screens/login.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget { @override
Widget build(BuildContext context) { return MaterialApp(
  routes: <String, WidgetBuilder>{
    '/login': (BuildContext context) => login()
  },
  debugShowCheckedModeBanner: false,
  theme: ThemeData(brightness: Brightness.dark), home: login(),
);
}
}
