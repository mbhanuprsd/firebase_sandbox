import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sandbox/models/book_model.dart';
import 'package:firebase_sandbox/utils/app_utils.dart';
import 'package:flutter/material.dart';

class BookItem extends StatefulWidget {
  final BookModel book;
  final bool bookSelection;
  BookItem(this.book, this.bookSelection);
  @override
  State<StatefulWidget> createState() {
    return new BookItemState(book, bookSelection);
  }
}

class BookItemState extends State<BookItem> {
  BookModel book;
  bool bookSelection;
  CollectionReference _collectionReference =
      Firestore.instance.collection('books');

  BookItemState(this.book, this.bookSelection);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: () {
            bookSelection ? checkoutBook(context) : addBookToDB(context);
          },
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: (book.imageUrl == null)
              ? Icon(
                  Icons.book,
                  size: 80.0,
                )
              : Image.network(
                  book.imageUrl,
                  height: 80.0,
                ),
          title: Text(
            book.name + "\nby " + book.author,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 2,
          ),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              book.description == null
                  ? new Container()
                  : Text(
                      book.description,
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              bookSelection
                  ? Text(
                      book.status
                          ? ("Booked by " + book.bookedBy.name)
                          : "Available",
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : new Container(),
            ],
          ),
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

  checkoutBook(BuildContext context) async {
    if (book.status) {
      AppUtils.showAlert(
          context,
          "Already Booked!",
          book.name +
              " is booked by " +
              book.bookedBy.name +
              ". You can book once they returned it.\nThank you!",
          "Ok", () {
        Navigator.of(context).pop();
      });
    } else {
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

  addBookToDB(BuildContext context) async {
    QuerySnapshot snap = await _collectionReference
        .where('googleId', isEqualTo: book.googleId)
        .snapshots()
        .first;
    if (snap != null && snap.documents != null && snap.documents.length > 0) {
      AppUtils.showAlert(context, "Book exists in the database",
          "You can book it going to book list.\nThank you!", "Ok", () {
        Navigator.of(context).pop();
      });
    } else {
      _collectionReference.add(book.toJson()).then((doc) {
        AppUtils.showAlert(context, "Book added to the database",
            "You can book it going to book list.\nThank you!", "Ok", () {
          Navigator.of(context).pop();
        });
      }).catchError((e) => print(e));
    }
  }
}
