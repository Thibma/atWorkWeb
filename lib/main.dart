import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_office_desktop/pages/login.dart';
import 'package:get/get.dart';

const colorTheme = Color(0xFF3f51b5);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: colorTheme,
      ),
      debugShowCheckedModeBanner: false,
      title: 'My Office Dashboard',
      home: HomePage(),
    );
  }
}
