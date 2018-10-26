import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Firebase',
      theme: new ThemeData(
         primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}
