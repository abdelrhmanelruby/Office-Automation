import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:nodemcu/screens/settings.dart';
import 'mdrawer.dart';
import 'package:nodemcu/screens/mdrawer.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;
  final dbRef = FirebaseDatabase.instance.reference();
  onUpdate3() {
    setState(() {
      value3 = !value3;
    });
  }

  onUpdate4() {
    setState(() {
      value4 = !value4;
    });
  }

  onUpdate5() {
    setState(() {
      value5 = !value5;
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
          stream: dbRef.child("Door").onValue,
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
                      "Door lock",
                      style: TextStyle(
                          color: value3
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
                        onUpdate3();
                        writeData1();
                      },
                      icon: Icon(
                        value3 ? Icons.lock_open : Icons.lock,
                        color: value3 ? Colors.lightBlue[300] : Colors.black,
                      ),
                      label: value3
                          ? Text("Unlock",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          : Text("Lock",
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
                      "Security",
                      style: TextStyle(
                          color: value4
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
                        onUpdate4();
                        writeData1();
                      },
                      icon: Icon(
                        value4 ? Icons.lock_open : Icons.lock,
                        color: value4 ? Colors.lightBlue[300] : Colors.black,
                      ),
                      label: value4
                          ? Text("Disarm",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          : Text("Arm",
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
                      "Door",
                      style: TextStyle(
                          color: value5
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
                        onUpdate5();
                        writeData1();
                      },
                      icon: Icon(
                        value5 ? Icons.lock_open : Icons.lock,
                        color: value5 ? Colors.lightBlue[300] : Colors.black,
                      ),
                      label: value5
                          ? Text("Open",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          : Text("Close",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                      elevation: 20,
                      backgroundColor: Colors.white,
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

  Future<void> writeData1() {
    dbRef.child("DoorLock").set({"switch": value3});
    dbRef.child("Security").set({"switch": value4});
    dbRef.child("Door").set({"switch": value5});
  }
}
