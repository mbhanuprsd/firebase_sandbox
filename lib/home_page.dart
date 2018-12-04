import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  final Function signOut;
  HomePage(this.signOut);

  @override
  State<StatefulWidget> createState() => new HomeState(signOut);
}

class HomeState extends State<HomePage> {
  final Function signOut;
  HomeState(this.signOut);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new RaisedButton(
          child: new Text(
            'Sign Out',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () => signOut(),
          color: Colors.blue,
        ),
      ),
    );
  }
}
