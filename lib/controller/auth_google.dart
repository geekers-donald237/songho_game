import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Effectuer la connexion avec Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Créer les identifiants pour l'utilisateur
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Connecter l'utilisateur à Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Sauvegarder les informations dans Firestore
      if (user != null) {
        await saveGoogleUserInfoToFirestore(user);
      }

      return userCredential;
    } catch (error) {
      print('Erreur lors de la connexion avec Google : $error');
      return null;
    }
  }

  Future<void> saveGoogleUserInfoToFirestore(User user) async {
    String uid = user.uid;
    String email = user.email ?? '';

    // Extract username from email
    String username = email.split("@")[0];

    try {
      await FirebaseFirestore.instance.collection('players').doc(uid).set({
        'uid': uid,
        'email': email,
        'usernameP1': username,
      });

      print(
          'Informations de connexion avec Google sauvegardées dans Firestore avec succès !');
    } catch (error) {
      print(
          'Erreur lors de la sauvegarde des informations de connexion avec Google dans Firestore : $error');
    }
  }
}
