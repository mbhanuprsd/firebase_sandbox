import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  // Header members
  String bookID;
  String name;
  String author;
  String description;
  bool status;
  BookUser bookedBy;

  BookModel(this.name, this.author, this.description);

  BookModel.fromSnapshot(DocumentSnapshot snapshot)
      : bookID = snapshot.documentID,
        name = snapshot['name'],
        author = snapshot['author'],
        description = snapshot['description'],
        status = snapshot['status'],
        bookedBy = BookUser.fromData(snapshot['bookedBy']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'author': author,
        'description': description,
        'status': status,
        'bookedBy': bookedBy.toJson()
      };
}

class BookUser {
  String name;
  String email;
  String userId;

  BookUser(this.name, this.email, this.userId);

  BookUser.fromData(dynamic data)
      : name = data['name'],
        email = data['email'],
        userId = data['userId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'userId': userId,
      };
}
