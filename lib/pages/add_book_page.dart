import 'package:firebase_sandbox/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddBookState();
  }
}

class AddBookState extends State<AddBookPage> {
  final formKey = new GlobalKey<FormState>();

  CollectionReference _collectionReference =
      Firestore.instance.collection('books');

  String _name;
  String _author;
  String _description;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Book'),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Book Name'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter book name' : null,
                onSaved: (value) => _name = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Author'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter Author' : null,
                onSaved: (value) => _author = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter Description' : null,
                onSaved: (value) => _description = value,
              ),
              new Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              new RaisedButton(
                child: new Text(
                  'Add',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () => addBookToDB(),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addBookToDB() async {
    final loginForm = formKey.currentState;
    loginForm.save();
    if (loginForm.validate()) {
      BookModel bookModel = new BookModel(_name, _author, _description);
      await _collectionReference
          .add(bookModel.toJson())
          .then((doc) => Navigator.pop(context))
          .catchError((e) => print(e));
    } else {
      print('Inavlid form');
    }
  }
}
