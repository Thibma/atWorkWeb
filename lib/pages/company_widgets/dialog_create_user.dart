import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/models/unit.dart';
import 'package:my_office_desktop/models/user_firestore.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/company.dart';
import '../../models/service.dart';
import '../../models/user.dart';

class DialogCreateUser extends StatefulWidget {
  DialogCreateUser({
    Key? key,
    required this.company,
    required this.services,
    required this.units,
  }) : super(key: key);

  final Company company;
  final List<List<Service>> services;
  final List<Unit> units;

  @override
  State<DialogCreateUser> createState() => _DialogCreateUserState();
}

class _DialogCreateUserState extends State<DialogCreateUser> {
  final TextEditingController lastnameEditingController =
      TextEditingController();

  final TextEditingController firstnameEditingController =
      TextEditingController();

  final TextEditingController mailEditingController = TextEditingController();

  final error = RxBool(false);

  final image = Rxn<Uint8List>();

  RxString query = RxString('');

  Role? selectedRole;
  Service? selectedService;

  List<Map<String, String>> dropdownServices = [];

  late Company company;
  late List<List<Service>> services;
  late List<Unit> units;

  void changed(String search) {
    query.value = search;
  }

  @override
  void initState() {
    super.initState();
    company = widget.company;
    services = widget.services;
    units = widget.units;

    int i = 0;
    for (Unit unit in units) {
      dropdownServices.add({unit.name: "unit"});
      for (Service service in services[i]) {
        dropdownServices.add({service.name: "service"});
      }
      i += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Créer un utilisateur',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                      hint: "Nom de famille *",
                      icon: Icons.person,
                      controller: lastnameEditingController),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                      hint: "Prénom *",
                      icon: Icons.person,
                      controller: firstnameEditingController),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                      hint: "Adresse mail *",
                      icon: Icons.mail,
                      controller: mailEditingController),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    items: ["Collaborateur", "Administrateur"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        if (newValue == "Collaborateur") {
                          selectedRole = Role.Collaborateur;
                        } else {
                          selectedRole = Role.Administrateur;
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Rôle *",
                      prefixIcon: Icon(
                        Icons.check_circle,
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
                    items: dropdownServices
                        .map((value) => DropdownMenuItem(
                              enabled: value.values.first == 'service'
                                  ? true
                                  : false,
                              value: value,
                              child: value.values.first == 'service'
                                  ? Text(value.keys.first)
                                  : Text(
                                      value.keys.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                            ))
                        .toList(),
                    onChanged: (Map<String, String>? newValue) {
                      if (newValue != null) {
                        for (List<Service> listService in services) {
                          for (Service service in listService) {
                            if (newValue.keys.first == service.name) {
                              selectedService = service;
                              return;
                            }
                          }
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Service *",
                      prefixIcon: Icon(
                        Icons.lan,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.image);
                                if (result != null) {
                                  image.value = result.files.first.bytes;
                                }
                              },
                              icon: Icon(Icons.add_a_photo),
                              style: ElevatedButton.styleFrom(
                                  primary: CustomTheme.colorTheme),
                              label: Text("Photo de profil")),
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
                                  Icons.person,
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
                          if (firstnameEditingController.text.isEmpty ||
                              lastnameEditingController.text.isEmpty ||
                              mailEditingController.text.isEmpty ||
                              selectedRole == null ||
                              selectedService == null) {
                            error.value = true;
                            return;
                          }
                          error.value = false;

                          waitingDialog();
                          try {
                            final firebaseUser =
                                await Authentication.signUpWithEmailAndPassword(
                                    mailEditingController.text,
                                    "password",
                                    context);
                            if (image.value != null) {
                              await FirebaseStorage.instance
                                  .ref("imageProfile/${firebaseUser?.uid}")
                                  .putData(
                                    image.value!,
                                    SettableMetadata(contentType: 'image/jpeg'),
                                  );
                            } else {
                              ByteData bytes = await rootBundle
                                  .load("assets/default_profile.png");
                              Uint8List rawData = bytes.buffer.asUint8List(
                                  bytes.offsetInBytes, bytes.lengthInBytes);
                              await FirebaseStorage.instance
                                  .ref("imageProfile/${firebaseUser?.uid}")
                                  .putData(
                                      rawData,
                                      SettableMetadata(
                                          contentType: 'image/jpeg'));
                            }

                            ConnectedUser user = await Network().createUser(
                                firstnameEditingController.text,
                                lastnameEditingController.text,
                                mailEditingController.text,
                                selectedRole!,
                                firebaseUser!.uid,
                                "imageProfile/${firebaseUser.uid}",
                                selectedService!);

                            final refUsers =
                                FirebaseFirestore.instance.collection('users');
                            final userDoc = refUsers.doc(firebaseUser.uid);
                            final newUser = UserFirestore.userFirebase(
                                idUser: firebaseUser.uid,
                                name: "${user.firstname} ${user.lastname}",
                                lastMessageTime: DateTime.now());
                            await userDoc.set(newUser.toJson());
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
}
