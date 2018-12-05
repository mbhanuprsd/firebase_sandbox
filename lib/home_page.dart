import 'dart:async';

import 'package:firebase_sandbox/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference _documentReference;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  String textUpdates;
  StreamSubscription<DocumentSnapshot> _subscription;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Home',
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () => signOut()
                .then((_) => afterLogout())
                .catchError((e) => print(e)),
          ),
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButtonColumn(Icons.add, 'Add', _add),
                buildButtonColumn(Icons.update, 'Update', _update),
                buildButtonColumn(Icons.delete, 'Delete', _delete),
                buildButtonColumn(Icons.file_download, 'Fetch', _fetch),
                buildButtonColumn(Icons.clear_all, 'Clear', clearUpdates),
              ],
            ),
            textUpdates == null
                ? new Container()
                : new Text(
                    textUpdates,
                    style: new TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
          ],
        ),
      ),
    );
  }

  void updateText(String text) {
    setState(() {
      if (textUpdates == null) {
        textUpdates = '';
      }
      textUpdates = textUpdates + "\n" + text;
    });
  }

  void clearUpdates() {
    setState(() {
      textUpdates = null;
    });
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Superman",
      "birthplace": "Krypton",
      "powers": "many..",
    };
    _documentReference.setData(data).whenComplete(() {
      print("Document added");
    }).catchError((e) {
      print(e);
    });
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Superman",
      "birthplace": "Krypton",
      "powers": "many..",
      "weakness": "Kryptonite",
    };
    _documentReference.updateData(data).whenComplete(() {
      print("Document updated");
    });
  }

  void _delete() {
    _documentReference.delete().whenComplete(() {
      print("Document deleted");
    });
  }

  void _fetch() {
    _documentReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        print(dataSnapshot.data['name'].toString() + " fetched");
      }
    }).catchError((e) => () {
          print(e);
        });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void afterLogout() {
    print("User logged out");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Column buildButtonColumn(IconData icon, String label, Function callBack) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: new Icon(icon),
          color: color,
          onPressed: callBack,
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      _documentReference =
          Firestore.instance.collection(user.email).document('Details');
      _subscription = _documentReference.snapshots().listen((dataSnapshot) {
        if (dataSnapshot.exists) {
          updateText(dataSnapshot.data['name'].toString() + " synced");
        }
      });
    }).catchError((e) {
      signOut();
      print("No user detected");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription?.cancel();
  }
}
