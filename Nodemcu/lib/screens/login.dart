import 'package:flutter/material.dart';
import 'package:nodemcu/screens/iotscreen.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool passwordvisibility = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Colors.lightBlue[200],
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Username'),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              obscureText: passwordvisibility,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: InkWell(
                    onTap: _togglepasswordvisibility,
                    child: Icon(
                      passwordvisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  )),
            ),
            SizedBox(
              height: 15.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IotScreen()));
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.lightBlue[100],
            )
          ],
        ),
      ),
    );
  }

  void _togglepasswordvisibility() {
    passwordvisibility = !passwordvisibility;
    setState(() {});
  }
}
