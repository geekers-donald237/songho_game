import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// Générer le hashCode de la partie
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
  print(hashCode);

  return hashCode;
}

/* void share() async {
Share.share('check out my website https://example.com');
} */
/* void shareGeneratedHashCode() async {
  String hashCode = generateHashCode();

  try {
    await FlutterShare.share(
      title: 'Code de la Partie',
      text: 'Code généré : $hashCode',
    );
  } catch (e) {
    print(e.toString());
  }
} */

// Enregistrer le hashCode sur Firebase
Future<void> saveHashCode(String uid, String hashCode) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('players').doc(hashCode).set(
      {
        'hashCode': uid,
      },
      SetOptions(merge: true), // Option pour fusionner les données
    );
    //print('Code sauvegardé avec succès');
  } catch (e) {
    print('$e');
  }
}

// Récupérer l'uid de l'utilisateur
Future<User> getCurrentUser() async {
  User user = FirebaseAuth.instance.currentUser!;

  if (user != null) {
    await user
        .reload(); // Recharge les données de l'utilisateur depuis Firebase
    //user = FirebaseAuth.instance.currentUser!;

    //print('UID: $uid');
  } else {
    print('Aucun utilisateur connecté');
  }
  return user;
}




