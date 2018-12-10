import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sandbox/items/book_list_item.dart';
import 'package:firebase_sandbox/models/book_model.dart';
import 'package:firebase_sandbox/pages/home_page.dart';
import 'package:firebase_sandbox/pages/search_books_page.dart';
import 'package:firebase_sandbox/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference _collectionReference;

class BookListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BookListState();
}

class BookListState extends State<BookListPage> {
  String textUpdates;
  List<BookModel> bookList = new List();
  StreamSubscription<QuerySnapshot> _subscription;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Book List',
        ),
        leading: IconButton(
          icon: new Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BookSearchPage())),
          ),
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (bookList == null || bookList.length == 0)
                ? new Text(
                    'No Books Available',
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  )
                : new Expanded(
                    child: new ListView.builder(
                        itemCount: bookList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new BookItem(
                            bookList[index],
                            true,
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _collectionReference = Firestore.instance.collection('books');
    _subscription = _collectionReference.snapshots().listen((dataSnapshot) {
      if (dataSnapshot != null && dataSnapshot.documents != null) {
        bookList = new List();
        for (DocumentSnapshot docSnap in dataSnapshot.documents) {
          bookList.add(BookModel.fromSnapshot(docSnap));
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
