import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String generateHashCode() {
  Random random = Random();
  BigInt inputInteger = BigInt.zero;
  for (int i = 0; i < 10; i++) {
    inputInteger =
        inputInteger * BigInt.from(10) + BigInt.from(random.nextInt(10));
  }
  var bytes = utf8.encode(inputInteger.toString());
  var hash = sha256.convert(bytes);
  String hashCode = hash.toString();

  // Limiter le hashcode à 4 chiffres
  hashCode = hashCode.substring(0, 4);

  return hashCode;
}

void copyCodeToClipboard(BuildContext context, String hashcode) {
  Clipboard.setData(ClipboardData(text: hashcode)).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code copié avec succès')),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Échec de la copie du Code')),
    );
  });
}

Future<void> saveHashCode(String uid, String hashCode) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('players').doc(hashCode).set(
      {
        'hashCode': uid,
        'userIdP1': hashCode,
      },
      SetOptions(merge: true), // Option pour fusionner les données
    );
    //print('Code sauvegardé avec succès');
  } catch (e) {
    print('Erreur lors de la sauvegarde du Code : $e');
  }
}

Future<User> getCurrentUser() async {
  User user = FirebaseAuth.instance.currentUser!;

  if (user != null) {
    await user
        .reload(); // Recharge les données de l'utilisateur depuis Firebase
    user = FirebaseAuth.instance.currentUser!;

    //print('UID: $uid');
  } else {
    print('Aucun utilisateur connecté');
  }
  return user;
}

Future<String> saveUidIfHashCodeExists(String hashCode, String uid) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('players')
      .where('hashCode', isEqualTo: hashCode)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        snapshot.docs.first;
    final String documentId = documentSnapshot.id;

    await FirebaseFirestore.instance.collection('players').doc(documentId).set(
        {'userIdP2': uid},
        SetOptions(merge: true)); // Ajoute l'uid au document existant
  }

  return uid;
}

Future<String> saveUsernameIfHashCodeExists(String hashCode, String uid) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('players')
      .where('hashCode', isEqualTo: hashCode)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        snapshot.docs.first;
    final String documentId = documentSnapshot.id;

    // Récupérer le document de l'utilisateur correspondant à l'UID
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('players').doc(uid).get();

    if (userSnapshot.exists) {
      final String username = userSnapshot.data()!['username'];

      await FirebaseFirestore.instance
          .collection('players')
          .doc(documentId)
          .set(
        {'usernameP2': username},
        SetOptions(merge: true),
      ); // Ajoute l'uid et le nom d'utilisateur au document existant
    }
  }

  return uid;
}