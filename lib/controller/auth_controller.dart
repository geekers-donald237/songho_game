import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/views/Start.dart';
//import 'package:songhogame/views/Start.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/models/user_model.dart' as model;
import 'package:songhogame/views/signup_screen.dart';

class AuthController extends GetxController {
/*   late Rx<File?> _pickedImage; */
  late Rx<User?> _user;
  User? get user => _user.value;
  /* File? get profilePhoto => _pickedImage.value; */

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _selectInitialScreen);
  }

  _selectInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LogInScreen());
    } else {
      Get.offAll(() => Start());
    }
  }

  void register(String name, String email, String password) async {
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential =
            await firebaseAuth.createUserWithEmailAndPassword(
                email: email.trim(), password: password);
        model.User user = model.User(
          uid: credential.user!.uid,
          name: name,
          email: email,
        );
        firestore
            .collection('players')
            .doc(credential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Register Failed', 'Please enter all credientials');
      }
    } catch (e) {
      Get.snackbar('Something went wrong', e.toString());
      print(e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(), password: password);
        print('Success');
      } else {
        Get.snackbar('Login Failed', 'Please enter valid email and password');
      }
    } catch (e) {
      Get.snackbar('Something went wrong', e.toString());
      print(e.toString());
    }
  }

// Déconnexion de l'utilisateur
  void logout(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
      // Effectuez d'autres opérations de nettoyage si nécessaire
      Future.delayed(Duration(seconds: 1), () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LogInScreen()),
          (route) => false,
        );
      });
      //Navigator.pushReplacementNamed(context,
      //'LogInScreen()'); // Redirection vers une page de connexion (/login)
    } catch (e) {
      // Gérez les erreurs éventuelles lors de la déconnexion
      print('Erreur lors de la déconnexion : $e');
    }
  }
}
