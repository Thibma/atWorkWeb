import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/widgets/dialog_waiting.dart';
import 'package:my_office_desktop/pages/widgets/dialog_warning.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/services/network.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/company.dart';
import '../../models/service.dart';
import '../../models/unit.dart';
import '../../services/place_api.dart';

class DialogEditUnit extends StatefulWidget {
  DialogEditUnit(
      {Key? key,
      required this.company,
      required this.unit,
      required this.services})
      : super(key: key);

  final Company company;
  final Unit unit;
  final List<Service> services;

  @override
  State<DialogEditUnit> createState() => _DialogEditUnitState();
}

class _DialogEditUnitState extends State<DialogEditUnit> {
  final TextEditingController nameEditingController = TextEditingController();

  final TextEditingController addressEditionController =
      TextEditingController();

  final TextEditingController nameServiceEditingController =
      TextEditingController();

  final error = RxBool(false);
  final errorService = RxBool(false);

  RxString query = RxString('');

  final sessionToken = Uuid().v4();

  String selectedPlaceId = "";

  late Company company;
  late Unit unit;
  late RxList<Service> services;

  void changed(String search) {
    query.value = search;
    print(query.value);
  }

  @override
  void initState() {
    super.initState();

    company = widget.company;
    unit = widget.unit;
    services = RxList(widget.services);

    nameEditingController.text = unit.name;
    addressEditionController.text = unit.address;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SingleChildScrollView(
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
                      "Services de l'unité",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Obx(
                      () => SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                              columns: [
                                DataColumn(label: Text("Nom")),
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Supprimer")),
                              ],
                              rows: services
                                  .map(
                                    (element) => DataRow(
                                      cells: [
                                        DataCell(Text(element.name)),
                                        DataCell(Text(element.id)),
                                        DataCell(
                                          ElevatedButton(
                                            onPressed: () async {
                                              bool? areYouSure =
                                                  await warningDialog();
                                              if (areYouSure != null) {
                                                if (areYouSure) {
                                                  bool deleteService =
                                                      await Network()
                                                          .deleteService(
                                                              element.id);
                                                  if (deleteService) {
                                                    services.remove(element);
                                                  }
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red),
                                            child: Text("Supprimer"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Créer un service",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldApp(
                        hint: "Nom du service *",
                        icon: Icons.title,
                        controller: nameServiceEditingController),
                    Obx(
                      () => Visibility(
                        visible: errorService.value,
                        child: Text(
                          "Merci de remplir tous les champs",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (nameServiceEditingController.text.isEmpty) {
                              errorService.value = true;
                              return;
                            }
                            errorService.value = false;

                            waitingDialog();
                            try {
                              Service service = await Network().createService(
                                  nameServiceEditingController.text, unit.id);
                              Get.back();
                              services.add(service);
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
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme),
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
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Modifier l'unité : ${unit.name}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                        future: Network()
                            .getAutocompletePlaces(query.value, sessionToken),
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
                                                selectedPlaceId = snapshot
                                                    .data![index].placeId;
                                                addressEditionController.text =
                                                    snapshot.data![index]
                                                        .description;
                                                query.value =
                                                    addressEditionController
                                                        .text;
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool? areYouSure = await warningDialog();
                        if (areYouSure != null) {
                          if (areYouSure) {
                            try {
                              bool deleteUnit =
                                  await Network().deleteUnit(unit.id);
                              if (deleteUnit) {
                                Get.back(
                                    result: Unit(
                                        id: "deleted",
                                        name: "name",
                                        latitude: 0,
                                        longitude: 0,
                                        altitude: 0,
                                        address: "address"));
                              }
                            } catch (e) {
                              Get.defaultDialog(
                                title: "Erreur lors de la création",
                                middleText: e.toString(),
                                contentPadding: EdgeInsets.all(20.0),
                                confirm: TextButton(
                                  onPressed: () =>
                                      Navigator.of(Get.context!).pop(),
                                  child: Text(
                                    'Fermer',
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme),
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text("Supprimer l'unité"),
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
                                (addressEditionController.text.isEmpty &&
                                    selectedPlaceId == "")) {
                              error.value = true;
                              return;
                            }
                            error.value = false;

                            waitingDialog();
                            try {
                              Place? place;
                              if (selectedPlaceId != '') {
                                place = await Network().getDetailPlace(
                                    selectedPlaceId, sessionToken);
                              } else {
                                place = null;
                              }

                              Unit editedUnit = await Network().editUnit(
                                  unit.id,
                                  unit.name == nameEditingController.text
                                      ? null
                                      : nameEditingController.text,
                                  selectedPlaceId == "" ? null : place);
                              Get.back();
                              Get.back(result: editedUnit);
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
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme),
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
      ),
    );
  }
}
