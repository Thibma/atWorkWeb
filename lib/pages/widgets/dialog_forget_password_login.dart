import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
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
        onPressed: () => {},
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
