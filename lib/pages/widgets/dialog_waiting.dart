import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

void waitingDialog() {
  Get.defaultDialog(
    title: "Connexion",
    content: CircularProgressIndicator(
      color: CustomTheme.colorTheme,
    ),
    barrierDismissible: false,
  );
}
