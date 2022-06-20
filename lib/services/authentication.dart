import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import 'network.dart';

class Authentication {
  static ConnectedUser? connectedUser;

  static Future<User?> initializeFirebase() async {
    await Firebase.initializeApp();

    // Initialize User
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        user = await FirebaseAuth.instance.authStateChanges().first;
        connectedUser = await Network().login(user!.email!);
      } catch (e) {
        return null;
      }
    }

    return user;
  }

  // Get UserFirebase
  static User? getFirebaseUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static void signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pop(context);
        Get.snackbar(
            "Inscription complétée", "Vous pouvez désormais vous connecter.",
            backgroundColor: Colors.white);
        return;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ("Mot de passe trop faible");
      } else if (e.code == 'email-already-in-use') {
        throw ("Un compte existe déjà avec cette adresse mail.");
      } else {
        throw ("Une erreur a eu lieu lors de l'inscripton.");
      }
    }
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password) async {
    User? user;
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } catch (e) {
      throw ("Erreur lors de la connexion");
    }
    return user;
  }
}
