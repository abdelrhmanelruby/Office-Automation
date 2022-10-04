import 'package:flutter/material.dart';
import 'package:nodemcu/screens/iotscreen.dart';
import 'Controls.dart';
import 'Security.dart';
import 'Camera.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(40),
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            leading: Icon(Icons.sensors),
            title: Text('Sensors',
                style: TextStyle(fontSize: 18, color: Colors.lightBlue[200])),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IotScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.control_point),
            title: Text('Controls',
                style: TextStyle(fontSize: 18, color: Colors.lightBlue[200])),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Controls()));
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Security',
                style: TextStyle(fontSize: 18, color: Colors.lightBlue[200])),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Security()));
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera',
                style: TextStyle(fontSize: 18, color: Colors.lightBlue[200])),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Camera()));
            },
          ),
        ],
      ),
    );
  }
}
