import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Déclaration des variables globales
List<int> data = List<int>.filled(14, 5);
List<int> dataSubsetP1 = [];
List<int> remainingData = [];

List<Color> colorListP1 = List<Color>.generate(7, (index) => Colors.red[300]!);


Future<List<int>> createAndSaveFirebaseTable(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(uid);
  CollectionReference onlinePartCollectionRef =
      documentRef.collection('onlinepart');

  try {
    dataSubsetP1 = data.sublist(0, 7);

    Map<String, dynamic> tableData = {
      'tableData': dataSubsetP1,
    };

    await onlinePartCollectionRef.doc(uid).set(tableData);
    if (kDebugMode) {
      print("Table créée et enregistrée avec succès");
    }
  } catch (error) {
    if (kDebugMode) {
      print("Une erreur s'est produite : $error");
    }
  }

  return dataSubsetP1;
}

// Mettre à jour les pions du joueur 2 dans la sous-collection secondP
void updatePawnsInSecondP(List<int> board) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(uid);
  CollectionReference secondPCollectionRef = documentRef.collection('secondP');

  try {
    DocumentSnapshot document = await documentRef.get();
    if (document.exists) {
      List<int> remainingData = board.sublist(7, 14); // Pions de l'index 7 à 13

      Map<String, dynamic> updatedData = {
        'remainingData': remainingData,
      };

      await secondPCollectionRef.doc(uid).set(updatedData);
      if (kDebugMode) {
        print('Pions mis à jour dans la sous-collection secondP.');
      }
    } else {
      if (kDebugMode) {
        print('Aucun document trouvé avec l\'ID de l\'utilisateur : $uid');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print(
          'Une erreur s\'est produite lors de la recherche du document : $error');
    }
  }
}

// Sauvegarder les pions du joueur 2 dans son compte sur firebase
Future<List<int>> saveRemainingDataList(String userIdP2) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(userIdP2);
  CollectionReference secondPCollectionRef = documentRef.collection('secondP');

  try {
    DocumentSnapshot document = await documentRef.get();
    if (document.exists) {
      remainingData = data.sublist(7, 14); // Valeurs restantes de la liste data

      Map<String, dynamic> updatedData = {
        'remainingData': remainingData,
      };

      await secondPCollectionRef.doc(userIdP2).set(updatedData);
      if (kDebugMode) {
        print('Valeurs de data ajoutées à la sous-collection secondP.');
      }
    } else {
      if (kDebugMode) {
        print('Aucun document trouvé avec userIdP2: $userIdP2');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Erreur lors de la recherche du document : $error');
    }
  }

  return remainingData;
}

