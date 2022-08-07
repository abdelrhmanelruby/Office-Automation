import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class IotScreen extends StatefulWidget {
  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  @override
  bool value = false;
  bool value2 = false;
  Color _color = Colors.red; //test..................
  int r, g, b;

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
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        title: Text('ROOM 1'),
        centerTitle: true,
        elevation: 5.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
        ],
      ),
      body: StreamBuilder(
          stream: dbRef.child("Data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              return Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Icon(
                  //         Icons.menu,
                  //         color: Colors.black,
                  //       ),
                  //       Text("MY ROOM",
                  //       style: TextStyle(
                  //         fontSize: 20, fontWeight: FontWeight.bold),
                  //       ),
                  //       Icon(Icons.settings)
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Temperature",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              snapshot.data.snapshot.value["Temperature:"]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Humidity",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          snapshot.data.snapshot.value["Humidity:"].toString() +
                              " %",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Gas detector",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          snapshot.data.snapshot.value["Gas detector:"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Light",
                      style: TextStyle(
                          color: value ? Colors.yellow : Colors.white,
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
                        color: value ? Colors.yellow : Colors.black,
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
                          color: value2 ? _color : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        onUpdate2();
                        writeData2();
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
                              r = int.parse('${color.red}');
                              g = int.parse('${color.green}');
                              b = int.parse('${color.blue}');
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
                  )
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
    //dbRef.child("Data").set({"Humidity:":0 , "Temperature:" :0,"Gas detector:":0});
    dbRef.child("LightState").set({"switch": value});
    //dbRef.child("rgb").set({"red": 0, "green": 255, "blue": 0});
  }

  Future<void> writeData2() {
    dbRef.child("RgbState").set({"switch": value2});
  }
}
