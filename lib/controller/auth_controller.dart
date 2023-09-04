import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:songhogame/constants.dart';
import 'package:songhogame/views/Start.dart';
import 'package:songhogame/views/login_screen.dart';
import 'package:songhogame/models/user_model.dart' as model;

String downloadURL = '';

class AuthController extends GetxController {
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;

  User? get user => _user.value;
  File? get profilePhoto => _pickedImage.value;

  File? get pathPhoto => null;

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _selectInitialScreen);
  }

  _selectInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => Start());
    } else {
      Get.offAll(() => Start());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void register(String name, String email, String password, File? image) async {
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential credential =
            await firebaseAuth.createUserWithEmailAndPassword(
                email: email.trim(), password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          uid: credential.user!.uid,
          name: name,
          email: email,
          profilePhoto: downloadUrl,
        );
        firestore
            .collection('players')
            .doc(credential.user!.uid)
            .set(user.toJson());
        Get.to(() => Start());
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
        Get.to(() => Start());
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
