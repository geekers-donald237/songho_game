import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:songhogame/models/online_modal.dart';
import 'package:songhogame/views/Start.dart';

void checkInternetAndOpenModal(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    print('Connecté à Internet');
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
}
