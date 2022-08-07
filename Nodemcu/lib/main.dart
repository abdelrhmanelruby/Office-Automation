import 'package:flutter/material.dart';
import 'package:nodemcu/screens/iotscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/iotscreen': (BuildContext context) => IotScreen()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: IotScreen(),
    );
  }
}
