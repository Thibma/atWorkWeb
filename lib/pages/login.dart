import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/pages/widgets/dialog_forget_password_login.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/company.dart';
import '../models/user.dart';
import '../services/network.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget loginPage(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: Stack(
        children: [
          Container(
              alignment: Alignment.topCenter,
              child: Image.asset("assets/logo_home.png")),
          Center(
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldApp(
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
                      TextFieldApp(
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
                          text: "Mot de passe oubli?? ?",
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loginPage(context);
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
        throw ("Impossible de r??cup??rer le User");
      }

      ConnectedUser? connectedUser = await Network().login(user.email!);
      if (connectedUser == null) {
        throw ("Erreur API pour le USER");
      }

      // Navigate to dashboard
      Authentication.connectedUser = connectedUser;
      if (connectedUser.role == Role.SuperAdmin) {
        Navigator.of(Get.context!).pop();
        Navigator.pushNamed(
            Get.context!, 'dashboard/${connectedUser.id}/companies');
      } else if (connectedUser.role == Role.Administrateur) {
        Navigator.of(Get.context!).pop();
        List<Company> company =
            await Network().getUserCompanies(Authentication.connectedUser!.id);
        Navigator.pushNamed(Get.context!, "/company/${company.first.id}/units");
      } else {
        throw ("Vous n'avez pas les privil??ges pour acc??der ?? ce site.");
      }
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
