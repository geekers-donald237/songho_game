import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Déclaration des variables globales
List<int> data = List<int>.filled(14, 5);
List<Color> colorList =
    List<Color>.generate(14, (index) => Color.fromARGB(255, 92, 91, 91));

void createAndSaveFirebaseTable(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(uid);
  CollectionReference onlinePartCollectionRef =
      documentRef.collection('onlinepart');

  Map<String, dynamic> tableData = {
    'tableData': data,
  };

  try {
    await onlinePartCollectionRef.doc(uid).set(tableData);
    if (kDebugMode) {
      print("Table créée et enregistrée avec succès");
    }
  } catch (error) {
    if (kDebugMode) {
      print("Une erreur s'est produite : $error");
    }
  }
}
