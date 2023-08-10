import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:songhogame/models/online_modal.dart';
import 'package:songhogame/onboarding/hashcode.dart';

// Déclaration des variables globales
String hashCode = '';
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

String inputValue = '';

// Fonction pour récupérer la valeur saisie dans le TextField
String getValueFromTextField(String value) {
  inputValue = value;
  //print(inputValue);

  return inputValue;
}

void onPressedButton() async {
  final inputHashCode = getValueFromTextField(
      inputValue); // Récupère la valeur saisie dans le TextField
  final result = await saveUidIfHashCodeExists(
      inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase

  if (result != null) {
    print('Le hashCode existe dans Firebase et l\'UID a été enregistré.');
    // Effectuez ici les actions à réaliser lorsque le hashCode existe et que l'UID a été enregistré
  } else {
    print('Le hashCode n\'existe pas dans Firebase.');
    // Effectuez ici les actions à réaliser lorsque le hashCode n'existe pas
  }
}

void performFirebaseActions() async {
  // Afficher l'indicateur de chargement
  EasyLoading.show(status: 'Recherche en cours...');

  try {
    //saveUidIfHashCodeExists(inputValue, user.uid);
/*     getUsernameFromFirebase(user.uid);
    saveUsernameIfHashCodeExists(hashCode, user.uid); */
    //saveUsernameIfHashCodeExists(inputValue, user.uid);
    // Simuler une pause pour représenter le temps d'exécution de la recherche
    await Future.delayed(Duration(seconds: 3));

    // Afficher un message de succès
    EasyLoading.showSuccess('Reussie');
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    EasyLoading.showError('Code absent');
  }

  // Masquer l'indicateur de chargement une fois la recherche terminée
  EasyLoading.dismiss();
}

// Récupération du username pour pouvoir l'utiliser dans la partie de jeu
/* class UserInformation {
  String uid;
  String? username;

  UserInformation(
    this.uid,
    this.username,
  );
} */

/* Future<UserInformation?> getUserInformationFromFirestore(String uid) async {
  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('players').doc(uid).get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        String? username = data['username'];
        UserInformation userInformation = UserInformation(uid, username);
        print('Données récupérées depuis Firestore : $userInformation');
        return userInformation;
      }
    }
    return null;
  } catch (error) {
    print(
        'Erreur lors de la récupération des informations de l\'utilisateur depuis Firestore : $error');
    return null;
  }
} */

/* String? globalUsername; // Variable globale pour stocker le nom d'utilisateur

Future<String?> getUsernameFromFirestore(String uid) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('players')
        .doc(user.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        String? username = data['usernameP2'];
        print('Nom d\'utilisateur récupéré depuis Firestore : $username');
        globalUsername =
            username; // Sauvegarde le nom d'utilisateur dans la variable globale
        return globalUsername;
      }
    }
    return null;
  } catch (error) {
    print(
        'Erreur lors de la récupération du nom d\'utilisateur depuis Firestore : $error');
    return null;
  }
} */
/* 
Future<String> useName = getUsernameFromFirebase(user.uid);

Future<String> getUsename(Future<String> useNAme) async {
  String myString = await useName;

  return myString;
}
*/

// CARD FOR PLAYERS INFOS
Card buildUserInfoCard(String useName) {
  return Card(
    child: ListTile(
      title: Text('Nom du player 2 : $useName'),
    ),
  );
}

Future<String> getUsernameFromFirebase(String uid) async {
  // Récupérer la référence de la collection "players" dans Firebase
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('players');

  // Récupérer le document correspondant à l'utilisateur donné
  DocumentSnapshot document = await playersCollection.doc(uid).get();

  // Vérifier si le document existe
  if (document.exists) {
    // Récupérer les données du document
    Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

    // Récupérer le nom d'utilisateur
    String usernameP2 = userData['usernameP1'];

    // Afficher le nom d'utilisateur dans la console
    print('Nom d\'utilisateur : $usernameP2');
    print(usernameP2.runtimeType);

    // Retourner le nom d'utilisateur
    return '$usernameP2';
  } else {
    // Retourner une valeur par défaut si l'utilisateur n'existe pas
    return 'Utilisateur introuvable';
  }
}
