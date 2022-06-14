import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html';

class Authentication {
  static Future<String?> initializeFirebase({
    required BuildContext context,
  }) async {
    await Firebase.initializeApp();
    late StreamSubscription<User?> user;
    user = FirebaseAuth.instance.authStateChanges().listen((users) {
      print(users);
    });

    final cookie = document.cookie!;
    final entity = cookie.split("; ").map((item) {
      final split = item.split("=");
      return MapEntry(split[0], split[1]);
    });
    final cookieMap = Map.fromEntries(entity);
    print(cookieMap);
    if (cookieMap.containsKey("uid")) {
      if (cookieMap["uid"]!.isNotEmpty) {
        return cookieMap["uid"];
      }
    }
    return null;
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
