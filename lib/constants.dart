import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

//COLORS
const backgroundColor = Colors.lightGreen;
var buttonColor = Colors.blue[400];
const borderColor = Colors.white;

//Firebase
var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;
var firebaseStorage = FirebaseStorage.instance;
