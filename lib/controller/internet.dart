import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:songhogame/models/online_page.dart';
import 'package:songhogame/views/Start.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/views/menuJeu.dart';

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

void checkInternetAndOpenPage(BuildContext context) async {
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
      // Affiche le OnlinePage si l'utilisateur est connecté
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnlinePage()),
      );
    } else {
      // Redirige vers l'écran de connexion si l'utilisateur n'est pas connecté
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    }
  } else {
    EasyLoading.showInfo('Connectez-vous à internet');
    // Gérer le cas où l'utilisateur n'est pas connecté à Internet.
  }
}

void checkInternet(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    if (kDebugMode) {
      print('Connecté à Internet');
    }
  } else {
    EasyLoading.showInfo('Connectez-vous à internet');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MenuJeu()),
    );
  }
}
