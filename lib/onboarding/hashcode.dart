import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songhogame/models/online_modal.dart';

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
    await firestore
        .collection('players')
        .doc(
            hashCode) // Utilisation de .doc() générera automatiquement un nouvel identifiant de document
        .set({
      'hashCode': uid,
      'userIdP1': hashCode,
    });
    //print('Code sauvegardé avec succès');
  } catch (e) {
    print('Erreur lors de la sauvegarde du hashCode : $e');
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

// Fonction pour rechercher le hashCode dans Firebase
/* Future<bool> searchHashCodeInFirebase(String hashCode) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('players')
      .where('hashCode', isEqualTo: hashCode)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
} */

Future<String> saveUidIfHashCodeExists(String hashCode, String uid) async {
  //User user = FirebaseAuth.instance.currentUser!;

  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('players')
      .where('hashCode', isEqualTo: hashCode)
      .limit(1)
      .get();
  
  if (snapshot.docs.isNotEmpty) {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs.first;
    final String uid = documentSnapshot.id;
    
    await FirebaseFirestore
        .instance
        .collection('players')
        .doc(uid)
        .set({'userIdP2': uid}, SetOptions(merge: true)); // Ajoute l'uid au document existant
  }
  return user.uid;
}