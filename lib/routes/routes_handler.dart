import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/dashboard_admin_page.dart';
import 'package:my_office_desktop/pages/login.dart';
import 'package:my_office_desktop/routes/application.dart';

import '../services/authentication.dart';

var rootHandler = Handler(
  handlerFunc: (context, parameters) {
    return FutureBuilder(
      future: Authentication.initializeFirebase(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          default:
            if (snapshot.hasError) {
              print(snapshot.data);

              return AlertDialog(
                title: Text('Erreur de connexion'),
                actions: [
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text('Fermer'),
                  )
                ],
              );
            } else {
              if (snapshot.data != null) {
                Future.delayed(Duration(milliseconds: 0))
                    .then((value) => redirect(context, snapshot));

                return Container();
              } else {
                return HomePage();
              }
            }
        }
      },
    );
  },
);

redirect(BuildContext context, AsyncSnapshot<User?> snapshot) {
  Application.router
      .navigateTo(context, "/dashboard/${snapshot.data!.uid}",
          transition: TransitionType.none)
      .then((value) => redirect(context, snapshot));
}

var dashboardHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (id == null) {
    return ErrorPage();
  } else {
    return DashboardAdminPage();
  }
});

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Une erreur a eu lieu."),
      ),
    );
  }
}
