import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/models/online_modal.dart';
import 'package:songhogame/views/Start.dart';
import 'package:songhogame/views/login_screen.dart';

/* void checkInternetAndOpenModal(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    if (kDebugMode) {
      print('Connecté à Internet');
    }
    openModal(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pas de connexion Internet'),
      ),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Start()));
    // Gérer le cas où l'utilisateur n'est pas connecté à Internet, par exemple, afficher un message d'erreur ou une notification
  }
} */

void checkInternetAndOpenModal(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    if (kDebugMode) {
      print('Connecté à Internet');
    }
    // Récupère l'utilisateur actuellement connecté
    if (currentUser != null) {
      // Affiche le BottomSheet si l'utilisateur est connecté
      openModal(context);
    } else {
      // Redirige vers l'écran de connexion si l'utilisateur n'est pas connecté
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pas de connexion Internet'),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Start()),
    );
    // Gérer le cas où l'utilisateur n'est pas connecté à Internet, par exemple, afficher un message d'erreur ou une notification
  }
}
