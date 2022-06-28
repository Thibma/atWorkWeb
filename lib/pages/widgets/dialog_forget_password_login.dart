import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/theme.dart';

Widget dialogForgetPassword(BuildContext context) {
  final TextEditingController mailEditingController = TextEditingController();

  return AlertDialog(
    title: const Text('Mot de passe oublié ?'),
    content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFieldApp(
            hint: "Adresse mail",
            icon: Icons.mail,
            controller: mailEditingController)),
    actions: [
      TextButton(
        onPressed: () async {
          try {
            await Authentication.resetPassword(mailEditingController.text);
            Get.back();
            Get.defaultDialog(
              title: "Mail envoyé",
              middleText:
                  "Merci de vérifier dans votre boite mail pour réinitialiser le mot de passe.",
              contentPadding: EdgeInsets.all(20.0),
              confirm: TextButton(
                onPressed: () => Navigator.of(Get.context!).pop(),
                child: Text(
                  'Fermer',
                  style: TextStyle(color: CustomTheme.colorTheme),
                ),
              ),
            );
          } catch (e) {
            Get.defaultDialog(
              title: "Erreur lors de la réinitialisation du mot de passe",
              middleText: e.toString(),
              contentPadding: EdgeInsets.all(20.0),
              confirm: TextButton(
                onPressed: () => Navigator.of(Get.context!).pop(),
                child: Text(
                  'Fermer',
                  style: TextStyle(color: CustomTheme.colorTheme),
                ),
              ),
            );
          }
        },
        child: const Text(
          "Envoyer",
          style: TextStyle(
            color: CustomTheme.colorTheme,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () => {Navigator.of(context).pop()},
        child: const Text(
          "Annuler",
          style: TextStyle(
            color: CustomTheme.colorTheme,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
