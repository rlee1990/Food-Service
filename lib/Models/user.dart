import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String email;

  User({this.uid, this.email, this.firstName, this.lastName});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    return User(
      uid: snapshot.data['uid'],
      firstName: snapshot.data['firstName'],
      lastName: snapshot.data['lastName'],
      email: snapshot.data['email'],
    );
  }

  toJason2() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid
    };
  }
}