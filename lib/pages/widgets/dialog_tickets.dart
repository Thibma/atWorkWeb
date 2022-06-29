import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/door_status.dart';
import 'package:my_office_desktop/models/unit.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/company.dart';
import '../../services/place_api.dart';

class DialogCreateTicket extends StatelessWidget {
  DialogCreateTicket({Key? key}) : super(key: key);

  final TextEditingController mailEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();

  final error = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Demande de licence AtWork',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                      hint: "Votre adresse mail *",
                      icon: Icons.mail,
                      controller: mailEditingController),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldAppMultiline(
                    hint: "Votre présentation et celle de votre entreprise *",
                    controller: descriptionEditingController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Visibility(
                      visible: error.value,
                      child: Text(
                        "Merci de remplir tous les champs",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                      TextButton(
                        onPressed: () async {
                          if (mailEditingController.text.isEmpty ||
                              descriptionEditingController.text.isEmpty) {
                            error.value = true;
                            return;
                          }
                          error.value = false;

                          waitingDialog();
                          try {
                            await Network().createTicket(
                                mailEditingController.text,
                                descriptionEditingController.text);
                            Get.back();
                            Get.back(result: true);
                          } catch (e) {
                            Navigator.pop(context);
                            Get.defaultDialog(
                              title: "Erreur lors de la création",
                              middleText: e.toString(),
                              contentPadding: EdgeInsets.all(20.0),
                              confirm: TextButton(
                                onPressed: () =>
                                    Navigator.of(Get.context!).pop(),
                                child: Text(
                                  'Fermer',
                                  style:
                                      TextStyle(color: CustomTheme.colorTheme),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Payer 299.99€",
                          style: TextStyle(
                            color: CustomTheme.colorTheme,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
