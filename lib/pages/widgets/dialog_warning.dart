import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

Future<bool?> warningDialog() async {
  bool warning = await Get.defaultDialog(
    title: "ATTENTION",
    content: Text(
      "Êtes-vous sur de vouloir faire cela ?"
    ),
    confirm: TextButton(onPressed: (() {
      Get.back(result: true);
    }), child: Text("Oui", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
    cancel: TextButton(onPressed: () {
      Get.back(result: false);
    }, child: Text("Non", style: TextStyle(color: CustomTheme.colorTheme),))
  );

  return warning;
}
