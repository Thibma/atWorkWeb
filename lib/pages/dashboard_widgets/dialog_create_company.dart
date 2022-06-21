import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

Widget dialogCreateCompany(BuildContext context) {
  final TextEditingController nameEditingController = TextEditingController();
  final image = Rxn<Uint8List>();
  final error = RxBool(false);

  return Dialog(
    insetPadding: EdgeInsets.all(10),
    child: Container(
      width: 500,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Créer une entreprise',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldApp(
                hint: "Nom de l'entreprise *",
                icon: Icons.title,
                controller: nameEditingController),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            image.value = result.files.first.bytes;
                          }
                        },
                        icon: Icon(Icons.add_a_photo),
                        style: ElevatedButton.styleFrom(
                            primary: CustomTheme.colorTheme),
                        label: Text("Ajouter une photo *")),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Obx(
                    () => image.value == null
                        ? Icon(
                            Icons.domain,
                            size: 100,
                          )
                        : Image.memory(
                            image.value!,
                            width: 100,
                            height: 100,
                          ),
                  ),
                ),
              ],
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
                    if (nameEditingController.text.isEmpty ||
                        image.value == null) {
                      error.value = true;
                      return;
                    }
                    error.value = false;

                    waitingDialog();
                    try {
                      String filename =
                          "${nameEditingController.text}${DateTime.now().toIso8601String().toString()}";
                      await Network()
                          .createCompany(nameEditingController.text, filename);
                      await FirebaseStorage.instance
                          .ref("companiesImages/$filename")
                          .putBlob(image.value!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      Navigator.pop(context);
                      Get.defaultDialog(
                        title: "Erreur lors de la création",
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
                    "Créer",
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
  );
}
