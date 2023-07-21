import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../modejeu/TwoPlayers.dart';

class GameController {
  final player = AudioCache();
  void playSound(String fileName) {
    player.play(fileName);
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      padding: const EdgeInsets.all(15.0),
      width: 500,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void WinnerSms(String sms, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'Successs ',
          ),
          content: Text(
            sms,
            style: TextStyle(
              fontSize:
                  24, // Taille de police plus petite que l'original (à ajuster selon vos préférences)
              fontWeight:
                  FontWeight.bold, // Texte en gras pour attirer l'attention
              color: Colors.black, // Couleur du texte
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0, // Retire l'ombre au survol
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const TwoPlayers()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void changeScreenOrientation(BuildContext context, Widget page) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
}
