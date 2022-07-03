import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/models/door.dart';
import 'package:my_office_desktop/models/unit.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_create_door.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_create_unit.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_edit_door.dart';
import 'package:my_office_desktop/pages/widgets/unit_card.dart';

import '../../models/company.dart';
import '../../services/network.dart';
import '../../theme.dart';
import '../widgets/dialog_warning.dart';
import '../widgets/textfield.dart';

class DoorsListWidget extends StatefulWidget {
  const DoorsListWidget({Key? key, required this.company}) : super(key: key);

  final Company company;

  @override
  State<DoorsListWidget> createState() => _ProfiUnitsidgetState();
}

class _ProfiUnitsidgetState extends State<DoorsListWidget> {
  late Company company;

  @override
  void initState() {
    super.initState();
    company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network().getCompanyDoors(company.id),
      builder: (context, AsyncSnapshot<List<Door>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              List<Door> doors = snapshot.requireData;
              return DoorListDone(
                doors: doors,
                company: company,
              );
            }
        }
      },
    );
  }
}

class DoorListDone extends StatefulWidget {
  DoorListDone({Key? key, required List<Door> doors, required this.company})
      : doorList = RxList(doors),
        super(key: key);

  final Company company;
  RxList<Door> doorList;

  @override
  State<DoorListDone> createState() => _DoorListDoneState();
}

class _DoorListDoneState extends State<DoorListDone> {
  final searchController = TextEditingController();

  RxList<Door> filteredList = RxList();

  late Company company;
  late RxList<Door> doorList;

  void changed(String query) {
    filteredList.value = doorList
        .where((element) =>
            element.tag.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    company = widget.company;
    doorList = widget.doorList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    List<Unit> unitList =
                        await Network().getCompanyUnits(company.id);
                    var reload = await Get.dialog(DialogCreateDoor(
                      company: company,
                      unit: unitList,
                    ));
                    if (reload != null) {
                      try {
                        final unitReload =
                            await Network().getCompanyDoors(company.id);
                        doorList.value = unitReload;
                        changed(searchController.text);
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                  label: Text("Créer une porte connectée"),
                  icon: Icon(Icons.add),
                  style:
                      ElevatedButton.styleFrom(primary: CustomTheme.colorTheme),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  child: TextFieldApp(
                    icon: Icons.search,
                    hint: "Rechercher",
                    controller: searchController,
                    changed: changed,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Obx(
          () => SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Tag")),
                  DataColumn(label: Text("Adresse IP")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Localisation")),
                  DataColumn(label: Text("Modifier")),
                  DataColumn(label: Text("Supprimer")),
                ],
                rows: filteredList.isEmpty && searchController.text.isEmpty
                    ? doorList
                        .map(
                          (element) => DataRow(
                            cells: [
                              DataCell(Text(element.id)),
                              DataCell(Text(element.tag)),
                              DataCell(Text(element.url)),
                              DataCell(Text(element.status.name)),
                              DataCell(Text(element.unit.name)),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    List<Unit> unitList = await Network()
                                        .getCompanyUnits(company.id);
                                    var reload =
                                        await Get.dialog(DialogEditDoor(
                                      door: element,
                                      company: company,
                                      unit: unitList,
                                    ));
                                    if (reload != null) {
                                      try {
                                        final unitReload = await Network()
                                            .getCompanyDoors(company.id);
                                        doorList.value = unitReload;
                                        changed(searchController.text);
                                      } catch (e) {
                                        rethrow;
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomTheme.colorTheme),
                                  child: Text("Modifier"),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      bool? areYouSure = await warningDialog();
                                      if (areYouSure != null) {
                                        if (areYouSure == true) {
                                          bool delete = await Network()
                                              .deleteDoor(element.id);
                                          if (delete) {
                                            doorList.remove(element);
                                            changed(searchController.text);
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      Get.defaultDialog(
                                        title:
                                            "Impossible de supprimer l'utilisateur",
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
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  child: Text("Supprimer"),
                                ),
                              )
                            ],
                          ),
                        )
                        .toList()
                    : filteredList
                        .map(
                          (element) => DataRow(
                            cells: [
                              DataCell(Text(element.id)),
                              DataCell(Text(element.tag)),
                              DataCell(Text(element.url)),
                              DataCell(Text(element.status.name)),
                              DataCell(Text(element.unit.name)),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    List<Unit> unitList = await Network()
                                        .getCompanyUnits(company.id);
                                    var reload =
                                        await Get.dialog(DialogEditDoor(
                                      door: element,
                                      company: company,
                                      unit: unitList,
                                    ));
                                    if (reload != null) {
                                      try {
                                        final unitReload = await Network()
                                            .getCompanyDoors(company.id);
                                        doorList.value = unitReload;
                                        changed(searchController.text);
                                      } catch (e) {
                                        rethrow;
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomTheme.colorTheme),
                                  child: Text("Modifier"),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      bool? areYouSure = await warningDialog();
                                      if (areYouSure != null) {
                                        if (areYouSure == true) {
                                          bool delete = await Network()
                                              .deleteDoor(element.id);
                                          if (delete) {
                                            doorList.remove(element);
                                            changed(searchController.text);
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      Get.defaultDialog(
                                        title:
                                            "Impossible de supprimer l'utilisateur",
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
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  child: Text("Supprimer"),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
