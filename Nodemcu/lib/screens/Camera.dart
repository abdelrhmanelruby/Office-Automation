import 'package:flutter/material.dart';
import 'package:nodemcu/screens/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'mdrawer.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  String urll;
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
          stream: dbRef.child("CAM").onValue,
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
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Camera",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue[300]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        urll = snapshot.data.snapshot.value["Ip:"];
                        openurl();
                      },
                      icon: Icon(Icons.camera),
                      label: Text(
                        "Stream",
                      ),
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

  openurl() {
    launch(urll);
  }
}
