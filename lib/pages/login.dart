import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/models/user.dart';
import 'package:my_office_desktop/pages/widgets/dialog_forget_password_login.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield_login.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget loginPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('At Work - Dashboard'),
        backgroundColor: CustomTheme.colorTheme,
      ),
      backgroundColor: const Color(0xFFf5f5f5),
      body: Center(
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textFieldLogin(
                hint: "Adresse mail",
                icon: Icons.mail,
                controller: mailController,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  textFieldLogin(
                    hint: "Mot de passe",
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SelectableText.rich(
                    TextSpan(
                      mouseCursor: SystemMouseCursors.click,
                      style: const TextStyle(color: CustomTheme.colorTheme),
                      text: "Mot de passe oublié ?",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              showDialog(
                                  context: context,
                                  builder: dialogForgetPassword)
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => signIn(),
                style: ElevatedButton.styleFrom(
                    primary: CustomTheme.colorTheme,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text("Connexion"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          case ConnectionState.none:
            return Center(
              child: Text("User connecté !"),
            );
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return AlertDialog(
                title: Text('Erreur de connexion'),
                actions: [
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text('Fermer'),
                  )
                ],
              );
            } else {
              return loginPage(context);
            }
        }
      },
    );
  }

  void signIn() async {
    if (mailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.defaultDialog(
          title: "Erreur de connexion",
          middleText: "Merci de remplir tous les champs",
          contentPadding: EdgeInsets.all(20.0),
          confirm: TextButton(
              onPressed: () => Navigator.of(Get.context!).pop(),
              child: Text(
                'Fermer',
                style: TextStyle(color: CustomTheme.colorTheme),
              )));
      return;
    }

    waitingDialog();

    try {
      User? user = await Authentication.signInWithEmailPassword(
          mailController.text, passwordController.text);

      if (user == null) {
        throw ("Impossible de récupérer le User");
      }

      document.cookie = "uid=${user.uid}";
      final cookie = document.cookie!;
      final entity = cookie.split("; ").map((item) {
        final split = item.split("=");
        return MapEntry(split[0], split[1]);
      });
      final cookieMap = Map.fromEntries(entity);
      print(cookieMap);

      ConnectedUser connectedUser = await Network().login(user.uid);

      // Navigate to dashboard
      Navigator.of(Get.context!).pop();
    } catch (err) {
      Navigator.of(Get.context!).pop();
      Get.defaultDialog(
          title: "Erreur de connexion",
          middleText: err.toString(),
          contentPadding: EdgeInsets.all(20.0),
          confirm: TextButton(
              onPressed: () => Navigator.of(Get.context!).pop(),
              child: Text(
                'Fermer',
                style: TextStyle(color: CustomTheme.colorTheme),
              )));
    }
  }
}
