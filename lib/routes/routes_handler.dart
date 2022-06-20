import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/pages/dashboard_admin_page.dart';
import 'package:my_office_desktop/pages/dashboard_widgets/demandes_list_widget.dart';
import 'package:my_office_desktop/pages/dashboard_widgets/profile_list_widget.dart';
import 'package:my_office_desktop/pages/login.dart';

import '../pages/dashboard_widgets/companies_list_widget.dart';
import '../services/authentication.dart';

var rootHandler = Handler(
  handlerFunc: (context, parameters) {
    return HomePage();
  },
);

var dashboardCompaniesHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (!userVerification(Authentication.getFirebaseUser()!.uid, id!)) {
    return ErrorPage();
  } else {
    CompaniesList widget = CompaniesList();
    return DashboardAdminPage(
      finalWidget: widget,
      title: "Liste des entreprises",
    );
  }
});

var dashboardDemandesHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (!userVerification(Authentication.getFirebaseUser()!.uid, id!)) {
    return ErrorPage();
  } else {
    DemandesListWidget widget = DemandesListWidget();
    return DashboardAdminPage(
        finalWidget: widget, title: "Demande des clients");
  }
});

var dashboardProfileHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (!userVerification(Authentication.getFirebaseUser()!.uid, id!)) {
    return ErrorPage();
  } else {
    ProfileListWidget widget = ProfileListWidget();
    return DashboardAdminPage(
        finalWidget: widget, title: "Profil administrateur");
  }
});

bool userVerification(String firebaseId, String userId) {
  if (firebaseId != Authentication.getFirebaseUser()?.uid) {
    return false;
  } else {
    if (firebaseId != Authentication.connectedUser?.idFirebase) {
      return false;
    } else {
      if (userId != Authentication.connectedUser?.id) {
        return false;
      } else {
        if (Authentication.connectedUser?.role != Role.SuperAdmin) {
          return false;
        } else {
          return true;
        }
      }
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Text("Une erreur a eu lieu."),
        ),
      ),
    );
  }
}
