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
import 'package:uuid/uuid.dart';

import '../../services/place_api.dart';

Widget dialogCreateUnit(BuildContext context) {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController addressEditionController =
      TextEditingController();
  final error = RxBool(false);
  RxString query = RxString('');
  final sessionToken = Uuid().v4();
  String selectedPlaceId = "";

  void changed(String search) {
    query.value = search;
    print(query.value);
  }

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
                  'Créer une unité',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldApp(
                    hint: "Nom de l'unité *",
                    icon: Icons.title,
                    controller: nameEditingController),
                SizedBox(
                  height: 20,
                ),
                TextFieldApp(
                  hint: "Adresse *",
                  icon: Icons.pin_drop,
                  controller: addressEditionController,
                  changed: changed,
                ),
                Obx(
                  () => FutureBuilder(
                    future: PlaceApiProvider(sessionToken)
                        .fetchSuggestions(query.value),
                    builder: (context,
                            AsyncSnapshot<List<Suggestion>> snapshot) =>
                        query.value == ''
                            ? Container()
                            : snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length > 5
                                          ? 5
                                          : snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(snapshot
                                              .data![index].description),
                                          onTap: () {
                                            selectedPlaceId =
                                                snapshot.data![index].placeId;
                                            addressEditionController.text =
                                                snapshot
                                                    .data![index].description;
                                            query.value =
                                                addressEditionController.text;
                                          },
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                  ),
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
                        if (nameEditingController.text.isEmpty) {
                          error.value = true;
                          return;
                        }
                        error.value = false;

                        waitingDialog();
                        try {
                          // await Network()
                          // .createUnit(nameEditingController.text, filename);
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
      ],
    ),
  );
}
