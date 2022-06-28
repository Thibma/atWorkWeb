import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/door.dart';
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

class DialogEditDoor extends StatefulWidget {
  DialogEditDoor({
    Key? key,
    required this.company,
    required this.unit,
    required this.door,
  }) : super(key: key);

  final Company company;
  final List<Unit> unit;
  final Door door;

  @override
  State<DialogEditDoor> createState() => _DialogEditDoorState();
}

class _DialogEditDoorState extends State<DialogEditDoor> {
  final TextEditingController tagEditingController = TextEditingController();

  final error = RxBool(false);

  RxString query = RxString('');

  late DoorStatus doorStatus;

  late Unit selectedUnit;

  late Company company;
  late List<Unit> unit;
  late Door door;
  late String defaultStatus;

  void changed(String search) {
    query.value = search;
    print(query.value);
  }

  @override
  void initState() {
    super.initState();

    company = widget.company;
    unit = widget.unit;
    door = widget.door;

    tagEditingController.text = door.tag;
    selectedUnit = door.unit;
    doorStatus = door.status;

    switch (doorStatus) {
      case DoorStatus.Enter:
        defaultStatus = "Entrée";
        break;
      case DoorStatus.Leave:
        defaultStatus = "Partir";
        break;
      case DoorStatus.Forbidden:
        defaultStatus = "Interdit";
        break;
      case DoorStatus.Open:
        defaultStatus = "Ouverte";
        break;
    }
  }

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
                    'Modifier une porte connectée',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                      hint: "Tag de la porte *",
                      icon: Icons.tag,
                      controller: tagEditingController),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    items: ["Entrée", "Partir", 'Interdit', 'Ouverte']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    value: defaultStatus,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        switch (newValue) {
                          case "Entrée":
                            doorStatus = DoorStatus.Enter;
                            break;
                          case "Partir":
                            doorStatus = DoorStatus.Leave;
                            break;
                          case "Interdit":
                            doorStatus = DoorStatus.Forbidden;
                            break;
                          case "Ouverte":
                            doorStatus = DoorStatus.Open;
                            break;
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Status *",
                      prefixIcon: Icon(
                        Icons.settings,
                        color: CustomTheme.colorTheme,
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      labelStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.only(left: 30, top: 14),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[50]!),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey[50]!),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    items: widget.unit
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name),
                            ))
                        .toList(),
                    value: door.unit.name,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        for (Unit resultUnit in widget.unit) {
                          if (resultUnit.name == newValue) {
                            selectedUnit = resultUnit;
                            return;
                          }
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Unité *",
                      prefixIcon: Icon(
                        Icons.apartment,
                        color: CustomTheme.colorTheme,
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                      labelStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.only(left: 30, top: 14),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[50]!),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey[50]!),
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                          if (tagEditingController.text.isEmpty) {
                            error.value = true;
                            return;
                          }
                          error.value = false;

                          waitingDialog();
                          try {
                            await Network().editDoor(
                                tagEditingController.text == door.tag
                                    ? null
                                    : tagEditingController.text,
                                doorStatus == door.status ? null : doorStatus,
                                selectedUnit.id == door.unit.id
                                    ? null
                                    : selectedUnit.id,
                                door.id);
                            Get.back();
                            Get.back(result: true);
                          } catch (e) {
                            Navigator.pop(context);
                            Get.defaultDialog(
                              title: "Erreur lors de la modification",
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
                          "Modifier",
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
