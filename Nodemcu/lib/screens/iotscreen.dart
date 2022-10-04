import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:nodemcu/screens/settings.dart';
import 'mdrawer.dart';
import 'package:nodemcu/screens/mdrawer.dart';

class IotScreen extends StatefulWidget {
  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  @override
  final dbRef = FirebaseDatabase.instance.reference();
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
          stream: dbRef.child("Data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              return Column(
                children: [
                  SizedBox(height: 50.0),
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
                                  color: Colors.lightBlue[200],
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
                                  color: Colors.lightBlue[50],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Humidity",
                          style: TextStyle(
                              color: Colors.lightBlue[200],
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
                              color: Colors.lightBlue[50],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Gas detector",
                          style: TextStyle(
                              color: Colors.lightBlue[200],
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
                              color: Colors.lightBlue[50],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
}
