import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  // Header members
  String bookID;
  String name;
  String author;
  String imageUrl;
  String description;
  String googleId;
  bool status = false;
  BookUser bookedBy;

  BookModel(
    this.name,
    this.author,
    this.imageUrl,
    this.description,
    this.googleId,
  );

  BookModel.fromSnapshot(DocumentSnapshot snapshot)
      : bookID = snapshot.documentID,
        name = snapshot['name'],
        author = snapshot['author'],
        description = snapshot['description'],
        status = snapshot['status'] == null ? false : snapshot['status'],
        bookedBy = snapshot['bookedBy'] == null
            ? null
            : BookUser.fromData(snapshot['bookedBy']),
        googleId = snapshot['googleId'],
        imageUrl = snapshot['imageUrl'];

  Map<String, dynamic> toJson() => {
        'bookId': bookID,
        'name': name,
        'author': author,
        'description': description,
        'status': status,
        'bookedBy': bookedBy?.toJson(),
        'imageUrl': imageUrl,
        'googleId': googleId
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
