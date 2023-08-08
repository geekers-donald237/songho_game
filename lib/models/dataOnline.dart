import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

var user = FirebaseAuth.instance.currentUser!;

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
  final hashCodeExists = await saveUidIfHashCodeExists(
      inputHashCode, user.uid); // Vérifie si le hashCode existe dans Firebase

  if (hashCodeExists != null) {
    // Enregistre l'uid si le hashCode existe
    await saveUidIfHashCodeExists(inputHashCode, user.uid);
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
    saveUidIfHashCodeExists(inputValue, user.uid);

    // Simuler une pause pour représenter le temps d'exécution de la recherche
    await Future.delayed(Duration(seconds: 2));

    // Afficher un message de succès
    EasyLoading.showSuccess('Recherche terminée avec succès');
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    EasyLoading.showError('Erreur lors de la recherche');
  }

  // Masquer l'indicateur de chargement une fois la recherche terminée
  EasyLoading.dismiss();
}

void initializeGame(String player1Id, String player2Id, String gameId) {
  // Effectuez ici les actions nécessaires pour initialiser la partie de jeu
  // en utilisant les IDs des joueurs et l'ID de la partie

  // Exemple:
  print(
      'Initialisation de la partie $gameId avec les joueurs $player1Id et $player2Id');

  // Lancez la partie
  startGame();
}

void startGame() {
  print('La partie de jeu est lancée !');
}

// Récupérer le debut de nom de votre adresse mail
void getEmailUsernameFromFirestore() {
  FirebaseFirestore.instance
      .collection('players')
      .doc(user.uid)
      .get()
      .then((DocumentSnapshot snapshot) {
    String email = snapshot.get('email');

    // Séparez l'adresse e-mail en deux parties, avant et après le "@"
    List<String> emailParts = email.split('@');
    String username = emailParts[0];

    // Imprimez la partie souhaitée
    print(username);
  });
}

void storeUsernameOnFirestore() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Vérifiez si l'utilisateur est connecté avec Google
  bool isGoogleSignedIn = await googleSignIn.isSignedIn();

  if (isGoogleSignedIn) {
    // Récupérez les informations de l'utilisateur connecté avec Google
    GoogleSignInAccount? currentUser = googleSignIn.currentUser;
    String email = currentUser?.email ?? '';

    // Séparez l'adresse e-mail en deux parties, avant et après le "@"
    List<String> emailParts = email.split('@');
    String username = emailParts[0];

    // Imprimez la partie souhaitée
    print(username);

    // Stockez le nom d'utilisateur sur Firestore
    try {
      await firestore.collection('players').doc(auth.currentUser!.uid).set({
        'username': username,
      }, SetOptions(merge: true));
      print('Nom d\'utilisateur stocké avec succès sur Firestore.');
    } catch (e) {
      print(
          'Erreur lors de la sauvegarde du nom d\'utilisateur sur Firestore: $e');
    }
  } else {
    print('Utilisateur non connecté avec Google.');
  }
}
