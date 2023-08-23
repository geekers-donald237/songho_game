import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:songhogame/models/online_page.dart';
import 'package:songhogame/onboarding/hashcode.dart';

// Déclaration des variables globales
List<int> data = List<int>.filled(14, 5);
List<Color> colorList = List<Color>.generate(14, (index) => Colors.grey[300]!);

void createAndSaveFirebaseTable(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(uid);
  CollectionReference onlinePartCollectionRef =
      documentRef.collection('onlinepart');

  Map<String, dynamic> tableData = {
    'tableData': data,
    'colorList':
        colorList.map((color) => color.value.toRadixString(16)).toList(),
  };

  try {
    await onlinePartCollectionRef.doc(uid).set(tableData);
    if (kDebugMode) {
      print(
          "Table créée et enregistrée avec succès dans la sous-collection 'onlinepart' de Firebase !");
    }
  } catch (error) {
    if (kDebugMode) {
      print(
          "Une erreur s'est produite lors de la création et de l'enregistrement de la table sur Firebase : $error");
    }
  }
}
