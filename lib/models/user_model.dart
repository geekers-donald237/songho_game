import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;

  User({
    required this.uid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": name,
        "email": email,
      };

  static User fromJson(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshotData['uid'],
      name: snapshotData['username'],
      email: snapshotData['email'],
    );
  }
}



