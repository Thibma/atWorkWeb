import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/main.dart';
import 'package:my_office_desktop/models/service.dart';
import 'package:my_office_desktop/pages/company_widgets/dialog_edit_unit.dart';
import 'package:my_office_desktop/theme.dart';

import '../../models/company.dart';
import '../../models/unit.dart';
import '../../services/network.dart';

class UnitCard extends StatefulWidget {
  const UnitCard({
    Key? key,
    required this.unit,
    required this.company,
  }) : super(key: key);

  final Unit unit;
  final Company company;

  @override
  State<UnitCard> createState() => _UnitCardState();
}

class _UnitCardState extends State<UnitCard> {

  late Rx<Unit> unit;
  late Company company;

  @override
  void initState() {
    super.initState();

    unit = Rx<Unit>(widget.unit);
    company = widget.company;

  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        List<Service> services = await Network().getUnitService(unit.value.id);
        Unit? updatedUnit = await Get.dialog(DialogEditUnit(company: company, unit: unit.value, services: services,));
        if (updatedUnit != null) {
          if (updatedUnit.id == "deleted") {
            navigatorKey.currentState?.pushReplacementNamed("/company/${company.id}/units");
          }
          unit.value = updatedUnit;
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomTheme.colorTheme),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apartment,
              size: 80,
              color: Colors.white,
            ),
            Obx(() => Text(
                unit.value.name,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
