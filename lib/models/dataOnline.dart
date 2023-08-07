import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    print(
        "Table créée et enregistrée avec succès dans la sous-collection 'onlinepart' de Firebase !");
  } catch (error) {
    print(
        "Une erreur s'est produite lors de la création et de l'enregistrement de la table sur Firebase : $error");
  }
}


late List<int> _board;
late List<Color> _colorList;

Future<void> retrieveFirebaseTable(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference playersCollectionRef = firestore.collection('players');
  DocumentReference documentRef = playersCollectionRef.doc(uid);
  CollectionReference onlinePartCollectionRef =
      documentRef.collection('onlinepart');

  try {
    DocumentSnapshot docSnapshot = await onlinePartCollectionRef.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      List<int> tableData = List<int>.from(data['tableData'] as List<dynamic>);
      List<String> colorList =
          List<String>.from(data['colorList'] as List<dynamic>);
      List<Color> colors =
          colorList.map((hex) => Color(int.parse(hex, radix: 16))).toList();

      setState(() {
        _board = tableData;
        _colorList = colors;
      });

      print('tableData: $tableData');
      print('colorList: $colorList');
      print('colors: $colors');
    } else {
      print(
          "Le document n'existe pas dans la sous-collection 'onlinepart' de Firebase.");
    }
  } catch (error) {
    print(
        "Une erreur s'est produite lors de la récupération des données depuis Firebase : $error");
  }
}

void setState(Null Function() param0) {}


void performFirebaseActions() async {
    // Afficher l'indicateur de chargement
    EasyLoading.show(status: 'Recherche en cours...');

    // Vos opérations de recherche sur Firebase ici
    // ...

    // Simuler une pause pour représenter le temps d'exécution de la recherche
    await Future.delayed(Duration(seconds: 30));

    // Masquer l'indicateur de chargement une fois la recherche terminée
    EasyLoading.dismiss();
  }


  void initializeGame(String player1Id, String player2Id, String gameId) {
  // Effectuez ici les actions nécessaires pour initialiser la partie de jeu
  // en utilisant les IDs des joueurs et l'ID de la partie

  // Exemple:
  print('Initialisation de la partie $gameId avec les joueurs $player1Id et $player2Id');

  // Lancez la partie
  startGame();
}

void startGame() {


  print('La partie de jeu est lancée !');
}