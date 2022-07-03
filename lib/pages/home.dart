import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/main.dart';
import 'package:my_office_desktop/pages/widgets/dialog_tickets.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/utils/responsive.dart';
import 'dart:js' as js;

import '../models/company.dart';
import '../models/role.dart';
import '../services/network.dart';
import '../theme.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/web/background.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HeaderHome(),
                ),
                BodyHome(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ResponsiveWidget.isSmallScreen(context)
        ? SingleChildScrollView(
            child: Column(
              children: [
                ExpandedText(screenSize: screenSize),
                ExpandedImage(screenSize: screenSize)
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Expanded(flex: 2, child: ExpandedText(screenSize: screenSize)),
                Expanded(flex: 1, child: ExpandedImage(screenSize: screenSize))
              ]);
  }
}

class ExpandedImage extends StatelessWidget {
  const ExpandedImage({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 50, right: screenSize.width / 15, left: screenSize.width / 15),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Column(
          children: [
            Image.asset(
            "assets/web/screen1.jpg",
            width: 350,
          ),
          ], 
        ),
      ),
    );
  }
}

class ExpandedText extends StatelessWidget {
  const ExpandedText({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 20),
          child: Text(
            "La nouvelle application\npour entreprise !",
            style:
                TextStyle(fontSize: 46, fontWeight: FontWeight.bold, height: 1),
            maxLines: 5,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 15),
          child: Text(
            "Restez proches, même de loin !\nAu bureau comme en télétravail, supprimons les barrières en entreprise ! Avec At Work, retrouvez en une seule application tous vos outils du quotidien ! Voici quelques fonctionalités :",
            style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            maxLines: 10,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              " • ",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 20),
            ),
            Expanded(
                child: Text(
              "Messagerie instantanée",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            ))
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              " • ",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 20),
            ),
            Expanded(
                child: Text(
              "Localisation en fonction de votre entreprise",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            ))
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              " • ",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 20),
            ),
            Expanded(
                child: Text(
              "Agendas syncronisés",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            ))
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              " • ",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 20),
            ),
            Expanded(
                child: Text(
              "Badges électroniques intégrés",
              style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            ))
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width / 15),
          child: Text(
            "Récupérez votre licence dès à présent en vous inscrivant et téléchargez l'application\ndisponible pour Android et iOS !",
            style: TextStyle(color: CustomTheme.colorTheme, fontSize: 16),
            maxLines: 10,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 10, right: screenSize.width / 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 80,
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  bool result = await Get.dialog(DialogCreateTicket());
                  if (result) {
                    Get.defaultDialog(
                      title: "La demande a bien été créer.",
                      middleText:
                          "Vous avez reçu un mail de votre demande, elle sera traitée dans les plus brefs délais par notre équipe.",
                      contentPadding: EdgeInsets.all(20.0),
                      confirm: TextButton(
                        onPressed: () => Navigator.of(Get.context!).pop(),
                        child: Text(
                          'Fermer',
                          style: TextStyle(color: CustomTheme.colorTheme),
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(CustomTheme.colorTheme),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                child: Text(
                  "Obtenir une licence",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 8, right: screenSize.width / 8),
          child: Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    js.context.callMethod('open', [
                      "https://play.google.com/store/apps/details?id=com.myoffice.esgi.myoffice"
                    ]);
                  },
                  child: Image.asset(
                    "assets/web/google_play.png",
                    width: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenSize.width / 7.25, right: screenSize.width / 7.25),
          child: Image.asset("assets/web/qrcode_google.png"),
        ),
      ],
    );
  }
}

class HeaderHome extends StatelessWidget {
  const HeaderHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ResponsiveWidget.isSmallScreen(context)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo_home.png",
                scale: 2,
              ),
              SizedBox(
                height: 80,
                width: 200,
                child: ElevatedButton(
                  onPressed: dashboardButton,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomTheme.colorTheme),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/logo_home.png",
                scale: 2,
              ),
              SizedBox(
                height: 80,
                width: 200,
                child: ElevatedButton(
                  onPressed: dashboardButton,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomTheme.colorTheme),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          );
  }

  void dashboardButton() async {
    if (Authentication.connectedUser == null) {
      navigatorKey.currentState?.pushNamed('login');
    } else {
      if (Authentication.connectedUser?.role == Role.SuperAdmin) {
        navigatorKey.currentState?.pushNamed(
            'dashboard/${Authentication.connectedUser?.id}/companies');
      } else if (Authentication.connectedUser?.role == Role.Administrateur) {
        List<Company> company =
            await Network().getUserCompanies(Authentication.connectedUser!.id);
        navigatorKey.currentState
            ?.pushNamed("/company/${company.first.id}/units");
      } else {
        navigatorKey.currentState?.pushNamed('login');
      }
    }
  }
}
