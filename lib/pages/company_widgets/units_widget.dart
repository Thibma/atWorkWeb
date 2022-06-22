import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/models/unit.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_create_unit.dart';
import 'package:my_office_desktop/pages/widgets/unit_card.dart';

import '../../models/company.dart';
import '../../services/network.dart';
import '../../theme.dart';
import '../widgets/textfield.dart';

class UnitsListWidget extends StatefulWidget {
  const UnitsListWidget({Key? key, required this.company}) : super(key: key);

  final Company company;

  @override
  State<UnitsListWidget> createState() => _ProfiUnitsidgetState();
}

class _ProfiUnitsidgetState extends State<UnitsListWidget> {
  late Company company;

  @override
  void initState() {
    super.initState();
    company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network().getCompanyUnits(company.id),
      builder: (context, AsyncSnapshot<List<Unit>> snapshot) {
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
              List<Unit> units = snapshot.requireData;
              return UnitListDone(
                units: units,
                company: company,
              );
            }
        }
      },
    );
  }
}

class UnitListDone extends StatelessWidget {
  UnitListDone({Key? key, required List<Unit> units, required this.company})
      : unitList = RxList(units),
        super(key: key);

  final Company company;
  RxList<Unit> unitList;
  final searchController = TextEditingController();
  RxList<Unit> filteredList = RxList();

  void changed(String query) {
    filteredList.value = unitList
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
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
                    var reload = await showDialog(
                        context: context, builder: dialogCreateUnit);
                    if (reload != null) {
                      try {
                        final unitReload =
                            await Network().getCompanyUnits(company.id);
                        unitList.value = unitReload;
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                  label: Text("Créer une unité"),
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
          () => GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: filteredList.isEmpty && searchController.text.isEmpty
                ? unitList.length
                : filteredList.length,
            itemBuilder: (BuildContext ctx, index) {
              return UnitCard(
                  unit: filteredList.isEmpty && searchController.text.isEmpty
                      ? unitList[index]
                      : filteredList[index]);
            },
          ),
        ),
      ],
    );
  }
}
