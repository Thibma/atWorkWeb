import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fluro/fluro.dart';
import 'package:my_office_desktop/routes/application.dart';
import 'package:my_office_desktop/routes/routes.dart';
import 'package:my_office_desktop/services/authentication.dart';

const colorTheme = Color(0xFF3f51b5);
User? user;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: colorTheme,
      ),
      debugShowCheckedModeBanner: false,
      title: 'My Office Dashboard',
      initialRoute: '/',
      onGenerateRoute: Application.router.generator,
    );
  }
}
