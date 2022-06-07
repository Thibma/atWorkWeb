import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

Widget textFieldLogin(
    {required String hint,
    required IconData icon,
    bool obscureText = false,
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    cursorColor: CustomTheme.colorTheme,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
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
  );
}
