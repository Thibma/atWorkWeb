import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/models/unit.dart';
import 'package:my_office_desktop/models/user.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/company.dart';
import '../../models/service.dart';

class DialogEditUser extends StatefulWidget {
  DialogEditUser({
    Key? key,
    required this.company,
    required this.services,
    required this.units,
    required this.user,
  }) : super(key: key);

  final Company company;
  final List<List<Service>> services;
  final List<Unit> units;
  final ConnectedUser user;

  @override
  State<DialogEditUser> createState() => _DialogCreateUserState();
}

class _DialogCreateUserState extends State<DialogEditUser> {
  final TextEditingController lastnameEditingController =
      TextEditingController();

  final TextEditingController firstnameEditingController =
      TextEditingController();

  final error = RxBool(false);

  final image = Rxn<Uint8List>();

  RxString query = RxString('');

  late Role selectedRole;
  late Service selectedService;

  List<Map<String, String>> dropdownServices = [];

  late Company company;
  late List<List<Service>> services;
  late List<Unit> units;
  late Rx<ConnectedUser> user;
  late Map<String, String> userService;

  void changed(String search) {
    query.value = search;
  }

  Future<String> loadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child(user.value.idImage);
    var url = await ref.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    super.initState();
    company = widget.company;
    services = widget.services;
    units = widget.units;
    user = Rx<ConnectedUser>(widget.user);
    lastnameEditingController.text = user.value.lastname;
    firstnameEditingController.text = user.value.firstname;
    userService = {user.value.services.first.name: 'service'};
    selectedRole = user.value.role;
    selectedService = user.value.services.first;

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
                    'Modifier un utilisateur',
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
                  DropdownButtonFormField(
                    items: ["Collaborateur", "Administrateur"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    value: user.value.role.name,
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
                    value: dropdownServices.firstWhere((element) =>
                        element.keys.first == userService.keys.first),
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
                              ? FutureBuilder(
                                  future: loadImage(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> image) {
                                    if (image.hasData) {
                                      return Image.network(
                                        image.data.toString(),
                                        width: 100,
                                        height: 100,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.person,
                                        size: 100,
                                      );
                                    }
                                  },
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
                              lastnameEditingController.text.isEmpty) {
                            error.value = true;
                            return;
                          }
                          error.value = false;

                          waitingDialog();
                          try {
                            if (image.value != null) {
                              await FirebaseStorage.instance
                                  .ref("imageProfile/${user.value.idFirebase}")
                                  .putData(
                                    image.value!,
                                    SettableMetadata(contentType: 'image/jpeg'),
                                  );
                            }

                            await Network().editUser(
                                firstnameEditingController.text ==
                                        user.value.firstname
                                    ? null
                                    : firstnameEditingController.text,
                                lastnameEditingController.text ==
                                        user.value.lastname
                                    ? null
                                    : lastnameEditingController.text,
                                selectedRole == user.value.role
                                    ? null
                                    : selectedRole,
                                selectedService == user.value.services.first
                                    ? null
                                    : selectedService,
                                user.value.id);
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
