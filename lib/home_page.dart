import 'package:firebase_sandbox/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final DocumentReference _documentReference =
    Firestore.instance.collection('myData').document('dummy');

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  String textUpdates;

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButtonColumn(Icons.add, 'Add', _add),
                buildButtonColumn(Icons.update, 'Update', _update),
                buildButtonColumn(Icons.delete, 'Delete', _delete),
                buildButtonColumn(Icons.cloud_download, 'Fetch', _fetch),
              ],
            ),
            textUpdates == null
                ? new Container()
                : new Text(
                    textUpdates,
                    style: new TextStyle(fontSize: 18.0),
                  ),
          ],
        ),
      ),
    );
  }

  void updateText(String text) {
    setState(() {
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
      updateText("Document added");
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
      updateText("Document updated");
    });
  }

  void _delete() {
    _documentReference.delete().whenComplete(() {
      updateText("Document deleted");
    });
  }

  void _fetch() {
    _documentReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        this.updateText(dataSnapshot.data['name'].toString() + " fetched");
      }
    }).catchError((e) => () {
          updateText(e);
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
}
