import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:nodemcu/screens/settings.dart';
import 'mdrawer.dart';

import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:nodemcu/screens/mdrawer.dart';

class Controls extends StatefulWidget {
  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  @override
  bool value = false;
  bool value2 = false;
  Color _color = Colors.red;
  int r = 255;
  int g = 0;
  int b = 0;

  final dbRef = FirebaseDatabase.instance.reference();
  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  onUpdate2() {
    setState(() {
      value2 = !value2;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ROOM 1',
          style: TextStyle(color: Colors.lightBlue[300]),
        ),
        centerTitle: true,
        elevation: 5.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => settings()));
              })
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder(
          stream: dbRef.child("LightState").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              return Column(
                children: [
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Light",
                      style: TextStyle(
                          color: value
                              ? Colors.lightBlue[300]
                              : Colors.lightBlue[100],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        onUpdate();
                        writeData();
                      },
                      icon: Icon(
                        Icons.lightbulb,
                        color: value ? Colors.lightBlue[300] : Colors.black,
                      ),
                      label: value
                          ? Text("ON",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          : Text("OFF",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                      elevation: 20,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "RGB",
                      style: TextStyle(
                          color: value2 ? _color : Colors.lightBlue[100],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        onUpdate2();
                        writeData();
                      },
                      icon: Icon(
                        Icons.lightbulb,
                        color: value2 ? _color : Colors.black,
                      ),
                      label: value2
                          ? Text("ON",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          : Text("OFF",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                      elevation: 20,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        CircleColorPicker(
                          initialColor: _color,
                          onChanged: (Color color) {
                            setState(() {
                              _color = color;
                              int r = int.parse('${color.red}');
                              int g = int.parse('${color.green}');
                              int b = int.parse('${color.blue}');
                              if (r < 125) {
                                r = 0;
                              }
                              if (g < 125) {
                                g = 0;
                              }
                              if (b < 125) {
                                b = 0;
                              }
                              dbRef
                                  .child("rgb")
                                  .set({"red": r, "green": g, "blue": b});
                            });
                          },
                          size: const Size(200, 200),
                          strokeWidth: 5.0,
                          thumbSize: 20,
                          colorCodeBuilder: (context, color) {
                            return Text(
                              'RGB(${color.red},${color.green},${color.blue})',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Text("please check your internet connection",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              );
          }),
    );
  }

  Future<void> writeData() {
    dbRef.child("LightState").set({"switch": value});
    dbRef.child("RgbState").set({"switch": value2});
    dbRef.child("rgb").set({"red": r, "green": g, "blue": b});
  }
}
