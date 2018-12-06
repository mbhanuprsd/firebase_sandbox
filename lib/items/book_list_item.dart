import 'package:firebase_sandbox/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookItem extends StatelessWidget {
  final BookModel book;
  BookItem(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: () {
            if (book.status) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Already Booked!"),
                      content: new Text(book.name +
                          " is booked by " +
                          book.bookedBy.name +
                          ". You can book once they returned it.\nThank you!"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              checkOutBook(book);
            }
          },
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Icon(
            Icons.book,
            color: Colors.white,
            size: 30.0,
          ),
          title: Text(
            book.name + "\nby " + book.author,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              book.description +
                  (book.status
                      ? ("\nBooked by " + book.bookedBy.name)
                      : 'Available'),
              style: TextStyle(color: Colors.white)),
          trailing: book.status
              ? Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 30.0,
                )
              : Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 30.0,
                ),
        ),
      ),
    );
  }

  void checkOutBook(BookModel book) async {
    var document = await Firestore.instance
        .collection('books')
        .document(book.bookID)
        .get();
    BookModel model = BookModel.fromSnapshot(document);
    FirebaseAuth.instance.currentUser().then((user) {
      model.bookedBy = BookUser(user.displayName, user.email, user.uid);
      model.status = true;
      Firestore.instance
          .collection('books')
          .document(book.bookID)
          .setData(model.toJson())
          .then((_) {})
          .catchError((e) => print(e));
    }).catchError((e) => print(e));
  }
}
