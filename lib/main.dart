import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fluro/fluro.dart';
import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/routes/application.dart';
import 'package:my_office_desktop/routes/routes.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/services/network.dart';

const colorTheme = Color(0xFF3f51b5);
User? user;
String routeAdminOrNot = "";
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //setUrlStrategy(PathUrlStrategy());
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  user = await Authentication.initializeFirebase();
  if (Authentication.connectedUser?.role == Role.SuperAdmin) {
    routeAdminOrNot = 'dashboard/${Authentication.connectedUser?.id}/companies';
  } else if (Authentication.connectedUser?.role == Role.Administrateur) {
    List<Company> company = await Network().getUserCompanies(Authentication.connectedUser!.id);
    routeAdminOrNot = "/company/${company.first.id}/units";
  }
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
      title: 'At Work',
      onGenerateRoute: Application.router.generator,
      initialRoute: user == null ? '/' : routeAdminOrNot,
      navigatorKey: navigatorKey,
    );
  }
}
