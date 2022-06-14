import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/routes/routes_handler.dart';

class Routes {
  static String root = "/";
  static String dashboard = "/dashboard/:id";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("Route not found!");
    });
    router.define(root, handler: rootHandler);
    //router.define(dashboard, handler: )
  }
}
