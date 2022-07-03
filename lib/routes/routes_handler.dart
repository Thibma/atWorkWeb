import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/main.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/pages/dashboard_admin_page.dart';
import 'package:my_office_desktop/pages/dashboard_widgets/demandes_list_widget.dart';
import 'package:my_office_desktop/pages/dashboard_widgets/profile_list_widget.dart';
import 'package:my_office_desktop/pages/home.dart';
import 'package:my_office_desktop/pages/login.dart';
import 'package:my_office_desktop/services/network.dart';

import '../models/company.dart';
import '../pages/company_widgets/doors_widget.dart';
import '../pages/company_widgets/units_widget.dart';
import '../pages/company_widgets/users_widget.dart';
import '../pages/dashboard_company_admin.dart';
import '../pages/dashboard_widgets/companies_list_widget.dart';
import '../services/authentication.dart';

import '../theme.dart';

var rootHandler = Handler(
  handlerFunc: (context, parameters) {
    return HomeWeb();
  },
);

var loginHandler = Handler(
  handlerFunc: (context, parameters) {
    return HomePage();
  },
);

var dashboardCompaniesHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  if (!userVerificationAdmin(Authentication.getFirebaseUser()!.uid, id!) ||
      Authentication.connectedUser == null) {
    return ErrorPage();
  } else {
    return DashboardAdminPage(
      mainWidget: CompaniesList(),
      titleWidget: "Liste des entreprises",
    );
  }
});

var dashboardDemandesHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  if (!userVerificationAdmin(Authentication.getFirebaseUser()!.uid, id!) ||
      Authentication.connectedUser == null) {
    return ErrorPage();
  } else {
    return DashboardAdminPage(
      mainWidget: DemandesListWidget(),
      titleWidget: "Demande des clients",
    );
  }
});

var dashboardProfileHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  if (!userVerificationAdmin(Authentication.getFirebaseUser()!.uid, id!) ||
      Authentication.connectedUser == null) {
    return ErrorPage();
  } else {
    return DashboardAdminPage(
      mainWidget: ProfileListWidget(),
      titleWidget: "Profil administrateur",
    );
  }
});

var companyUnitsHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (id == null) {
    return ErrorPage();
  }
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  return FutureBuilder(
    future: Future.wait([userVerification(id), Network().getCompany(id)]),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data![0] == false) {
          return ErrorPage();
        }
        return DashboardCompanies(
          titleWidget: "Liste des unités",
          mainWidget: UnitsListWidget(company: snapshot.data![1]),
          company: snapshot.data![1],
        );
      } else if (snapshot.hasError) {
        return ErrorPage();
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      }
    },
  );
});

var companyUsersHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (id == null) {
    return ErrorPage();
  }
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  return FutureBuilder(
    future: Future.wait([userVerification(id), Network().getCompany(id)]),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data![0] == false) {
          return ErrorPage();
        }
        return DashboardCompanies(
          titleWidget: "Liste des utilisateurs",
          mainWidget: UsersListWidget(company: snapshot.data![1]),
          company: snapshot.data![1],
        );
      } else if (snapshot.hasError) {
        return ErrorPage();
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      }
    },
  );
});

var companyDoorsHandler = Handler(handlerFunc: (context, parameters) {
  String? id = parameters["id"]?.first;
  if (id == null) {
    return ErrorPage();
  }
  if (Authentication.getFirebaseUser() == null) {
    return ErrorPage();
  }
  return FutureBuilder(
    future: Future.wait([userVerification(id), Network().getCompany(id)]),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data![0] == false) {
          return ErrorPage();
        }
        return DashboardCompanies(
          titleWidget: "Liste des portes connectées",
          mainWidget: DoorsListWidget(company: snapshot.data![1]),
          company: snapshot.data![1],
        );
      } else if (snapshot.hasError) {
        return ErrorPage();
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      }
    },
  );
});

bool userVerificationAdmin(String firebaseId, String userId) {
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

Future<bool> userVerification(String companyId) async {
  if (Authentication.connectedUser == null) {
    return false;
  }

  if (Authentication.connectedUser?.role == Role.SuperAdmin) {
    return true;
  }

  if (Authentication.connectedUser?.role == Role.Collaborateur) {
    return false;
  }

  final companies =
      await Network().getUserCompanies(Authentication.connectedUser!.id);

  bool result = false;
  for (var element in companies) {
    if (element.id == companyId) {
      result = true;
    }
  }

  return result;
}

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Une erreur a eu lieu."),
            ElevatedButton(
              onPressed: () async {
                if (Authentication.getFirebaseUser() != null &&
                    Authentication.connectedUser != null) {
                  if (Authentication.connectedUser?.role == Role.SuperAdmin) {
                    navigatorKey.currentState?.pushReplacementNamed(
                        "/dashboard/${Authentication.connectedUser?.id}/companies");
                  } else if (Authentication.connectedUser?.role ==
                      Role.Administrateur) {
                    List<Company> company = await Network()
                        .getUserCompanies(Authentication.connectedUser!.id);
                    navigatorKey.currentState?.pushReplacementNamed(
                        "/company/${company.first.id}/units");
                  } else {
                    navigatorKey.currentState?.pushReplacementNamed('/');
                  }
                } else {
                  navigatorKey.currentState?.pushReplacementNamed('/');
                }
              },
              style: ElevatedButton.styleFrom(primary: CustomTheme.colorTheme),
              child: Text("Cliquez ici pour être redirigé."),
            )
          ],
        ),
      ),
    );
  }
}
