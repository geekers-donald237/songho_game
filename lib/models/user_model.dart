import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  String profilePhoto;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "usernameP1": name,
        "email": email,
        "pathPhoto": profilePhoto,
      };

  static User fromJson(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshotData['uid'],
      name: snapshotData['usernameP1'],
      email: snapshotData['email'],
      profilePhoto: snapshot['profilePhoto'],
    );
  }
}
