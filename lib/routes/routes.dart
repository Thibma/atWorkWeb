import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/company_widgets/units_widget.dart';
import 'package:my_office_desktop/pages/dashboard_company_admin.dart';
import 'package:my_office_desktop/routes/routes_handler.dart';

class Routes {
  static String root = "/";

  static String dashboardCompanies = "/dashboard/:id/companies";
  static String dashboardDemandes = "/dashboard/:id/demandes";
  static String dashboardProfil = "/dashboard/:id/profil";

  static String companyUnits = "/company";

  static void configureRoutes(FluroRouter router) {
    router.define(root,
        handler: rootHandler, transitionType: TransitionType.none);

    router.define(dashboardCompanies,
        handler: dashboardCompaniesHandler,
        transitionType: TransitionType.none);
    router.define(dashboardDemandes,
        handler: dashboardDemandesHandler, transitionType: TransitionType.none);
    router.define(dashboardProfil,
        handler: dashboardProfileHandler, transitionType: TransitionType.none);

    router.define(companyUnits,
        handler: Handler(handlerFunc: ((context, parameters) {
      return DashboardCompanies(
        title: "Liste des unités",
        finalWidget: UnitsListWidget(),
      );
    })));

    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ErrorPage();
    });
  }
}
