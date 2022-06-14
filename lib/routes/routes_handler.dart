import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/login.dart';

var rootHandler = Handler(
  handlerFunc: (context, parameters) {
    return HomePage();
  },
);

var dashboardHandler = Handler(handlerFunc: (context, parameters) {});

//class 