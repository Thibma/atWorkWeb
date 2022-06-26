import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/models/service.dart';

import 'package:my_office_desktop/models/user.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_create_user.dart';

import '../../models/company.dart';
import '../../models/unit.dart';
import '../../services/network.dart';
import '../../theme.dart';
import '../widgets/textfield.dart';

class UsersListWidget extends StatefulWidget {
  const UsersListWidget({Key? key, required this.company}) : super(key: key);

  final Company company;

  @override
  State<UsersListWidget> createState() => _ProfiConnectedUsersidgetState();
}

class _ProfiConnectedUsersidgetState extends State<UsersListWidget> {
  late Company company;

  @override
  void initState() {
    super.initState();
    company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network().getCompanyUsers(company.id),
      builder: (context, AsyncSnapshot<List<ConnectedUser>> snapshot) {
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
              List<ConnectedUser> users = snapshot.requireData;
              return UserListDone(
                users: users,
                company: company,
              );
            }
        }
      },
    );
  }
}

class UserListDone extends StatelessWidget {
  UserListDone(
      {Key? key, required List<ConnectedUser> users, required this.company})
      : usersList = RxList(users),
        super(key: key);

  final Company company;
  RxList<ConnectedUser> usersList;
  final searchController = TextEditingController();
  RxList<ConnectedUser> filteredList = RxList();

  void changed(String query) {
    filteredList.value = usersList
        .where((element) =>
            element.firstname.toLowerCase().contains(query.toLowerCase()) ||
            element.lastname.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
                    final units = await Network().getCompanyUnits(company.id);
                    List<List<Service>> services = [];
                    for (Unit unit in units) {
                      List<Service> service =
                          await Network().getUnitService(unit.id);
                      services.add(service);
                    }
                    var reload = await Get.dialog(DialogCreateUser(
                      company: company,
                      units: units,
                      services: services,
                    ));
                    if (reload != null) {
                      try {
                        final userReload =
                            await Network().getCompanyUsers(company.id);
                        usersList.value = userReload;
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                  label: Text("Créer un utilisateur"),
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
                  DataColumn(label: Text("Prénom")),
                  DataColumn(label: Text("Nom")),
                  DataColumn(label: Text("Adresse mail")),
                  DataColumn(label: Text("ID Firebase")),
                  DataColumn(label: Text("Rôle")),
                  DataColumn(label: Text("Services")),
                  DataColumn(label: Text("Modifier")),
                  DataColumn(label: Text("Supprimer")),
                ],
                rows: filteredList.isEmpty && searchController.text.isEmpty
                    ? usersList
                        .map(
                          (element) => DataRow(
                            cells: [
                              DataCell(Text(element.firstname)),
                              DataCell(Text(element.lastname)),
                              DataCell(Text(element.email)),
                              DataCell(Text(element.idFirebase)),
                              DataCell(Text(element.role.name)),
                              DataCell(Text(element.serviceNames())),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomTheme.colorTheme),
                                  child: Text("Modifier"),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {},
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
                              DataCell(Text(element.firstname)),
                              DataCell(Text(element.lastname)),
                              DataCell(Text(element.email)),
                              DataCell(Text(element.idFirebase)),
                              DataCell(Text(element.role.name)),
                              DataCell(Text(element.serviceNames())),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: CustomTheme.colorTheme),
                                  child: Text("Modifier"),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  child: Text("Supprimer"),
                                ),
                              )
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
