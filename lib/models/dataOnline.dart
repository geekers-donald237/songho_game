import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:songhogame/models/online_page.dart';
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
    await Future.delayed(Duration(seconds: 4));

    // Afficher un message de succès
    EasyLoading.showSuccess('Reussie');
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    EasyLoading.showError('Code absent');
  }

  // Masquer l'indicateur de chargement une fois la recherche terminée
  EasyLoading.dismiss();
}

// CARD FOR PLAYERS INFOS
Card buildUserInfoCard(String useName) {
  return Card(
    child: ListTile(
      title: Text('Nom du player 2 : $useName'),
    ),
  );
}

/* Future<String> getUsernameFromFirebase(String uid) async {
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
    String usernameP1 = userData['usernameP1'];

    // Afficher le nom d'utilisateur dans la console
/*     print('Nom d\'utilisateur : $usernameP2');
    print(usernameP2.runtimeType); */

    // Retourner le nom d'utilisateur
    return '$usernameP2';
  } else {
    // Retourner une valeur par défaut si l'utilisateur n'existe pas
    return 'Utilisateur introuvable';
  }
} */

Future<List<String>> getUsernameFromFirebase(String uid) async {
  // Récupérer la référence de la collection "players" dans Firebase
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('players');

  // Récupérer le document correspondant à l'utilisateur donné
  DocumentSnapshot document = await playersCollection.doc(uid).get();

  // Initialiser une liste pour stocker les noms d'utilisateur
  List<String> usernames = [];

  // Vérifier si le document existe
  if (document.exists) {
    // Récupérer les données du document
    Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

    // Récupérer le nom d'utilisateur P2 et l'ajouter à la liste
    if (userData.containsKey('usernameP1')) {
      String usernameP1 = userData['usernameP1'];
      usernames.add(usernameP1);
    }

    // Récupérer le nom d'utilisateur P1 et l'ajouter à la liste
    if (userData.containsKey('usernameP1')) {
      String usernameP2 = userData['usernameP1'];
      usernames.add(usernameP2);
    }

    // Retourner la liste de noms d'utilisateur
    return usernames;
  } else {
    // Retourner une liste vide si l'utilisateur n'existe pas
    return usernames;
  }
}

/* Future<String> player1() async {
  // Appeler la fonction getUsernameFromFirebase pour obtenir les noms d'utilisateur
  List<String> usernames = await getUsernameFromFirebase(user.uid);

  // Vérifier si la liste usernames n'est pas vide
  if (usernames.isNotEmpty) {
    String players1 = usernames[0]; // Accéder à la valeur du premier indice

    print('Nom d\'utilisateur du premier indice : $players1');
    print(players1.runtimeType);

    return players1;
  }

  // Retourner une valeur par défaut si la liste est vide
  return "Aucun nom d'utilisateur trouvé";
}

Future<String> player2() async {
  // Appeler la fonction getUsernameFromFirebase pour obtenir les noms d'utilisateur
  List<String> usernames = await getUsernameFromFirebase(user.uid);

  // Vérifier si la liste usernames n'est pas vide
  if (usernames.isNotEmpty) {
    String players2 = usernames[1]; // Accéder à la valeur du premier indice

    print('Nom d\'utilisateur du premier indice : $players2');

    return players2;
  }

  // Retourner une valeur par défaut si la liste est vide
  return "Aucun nom d'utilisateur trouvé";
} */


