import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/pages/widgets/drawer_list.dart';
import 'package:my_office_desktop/pages/widgets/profile_card.dart';
import 'package:my_office_desktop/theme.dart';
import 'package:my_office_desktop/services/authentication.dart';


class DashboardAdminPage extends StatefulWidget {
  DashboardAdminPage(
      {Key? key, required Widget finalWidget, required String title})
      : mainWidget = finalWidget,
        titleWidget = title,
        super(key: key);

  final Widget mainWidget;
  final String titleWidget;

  @override
  _DashboardAdminPage createState() => _DashboardAdminPage();
}

class _DashboardAdminPage extends State<DashboardAdminPage> {
  late Widget mainWidget;
  late String titleWidget;

  @override
  void initState() {
    mainWidget = widget.mainWidget;
    titleWidget = widget.titleWidget;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeSuperAdmin(widget: mainWidget, title: titleWidget,);
  }
}

class HomeSuperAdmin extends StatelessWidget {
  const HomeSuperAdmin({Key? key, required Widget widget, required String title})
      : mainWidget = widget,
      titleWidget = title,
        super(key: key);

  final Widget mainWidget;
  final String titleWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Center(
                          child: Image.asset(
                        "assets/logo.png",
                        scale: 0.2,
                      )),
                    ),
                    DrawerListTile(
                      title: "Entreprises",
                      icon: Icons.domain,
                      press: () {
                        Navigator.pushNamed(context,
                            '/dashboard/${Authentication.getFirebaseUser()?.uid}/companies');
                      },
                    ),
                    DrawerListTile(
                        title: "Demandes",
                        icon: Icons.receipt_long,
                        press: () {
                          Navigator.pushNamed(context,
                              '/dashboard/${Authentication.getFirebaseUser()?.uid}/demandes');
                        }),
                    DrawerListTile(
                      title: "Profil",
                      icon: Icons.person,
                      press: () {Navigator.pushNamed(context,
                              '/dashboard/${Authentication.getFirebaseUser()?.uid}/profil');},
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10.0),
                            child: Text(
                              titleWidget,
                              style: Theme.of(context).textTheme.headline4,
                            )),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 25.0, bottom: 10.0),
                          child: ProfileCard(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: mainWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    Key? key,
    required this.companies,
  }) : super(key: key);

  final Company companies;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomTheme.colorTheme),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.domain,
              size: 80,
              color: Colors.white,
            ),
            Text(
              companies.name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}



