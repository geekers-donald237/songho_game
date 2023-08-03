/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    //
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtenir les informations de l'utilisateur lrs du sign In
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //Créer de nouveaux identifiants pour l'utilisateur.
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Connexion
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
 */

// Importation des packages nécessaires
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Fonction pour l'authentification avec Google
class AuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Créer une instance de GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Demander l'authentification de l'utilisateur
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        // Récupérer les informations d'identification
        final GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;

        // Utiliser les informations d'identification pour l'authentification Firebase
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Utiliser les informations d'identification pour se connecter à Firebase
        await FirebaseAuth.instance.signInWithCredential(credential);

        // L'authentification avec Google est réussie
        print('Authentification avec Google réussie');

        // Rediriger vers une autre page après une authentification réussie
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // L'utilisateur a annulé l'authentification
        print('Authentification avec Google annulée');
      }
    } catch (error) {
      // Une erreur s'est produite lors de l'authentification avec Google
      print('Erreur d\'authentification avec Google: $error');
    }
  }
}
