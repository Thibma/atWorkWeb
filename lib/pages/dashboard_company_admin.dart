import 'package:flutter/material.dart';
import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/pages/widgets/drawer_list.dart';
import 'package:my_office_desktop/pages/widgets/profile_card.dart';
import 'package:my_office_desktop/theme.dart';

import '../services/authentication.dart';

class DashboardCompanies extends StatefulWidget {
  const DashboardCompanies(
      {Key? key,
      required this.mainWidget,
      required this.titleWidget,
      required this.company})
      : super(key: key);

  final Widget mainWidget;
  final String titleWidget;
  final Company company;

  @override
  State<DashboardCompanies> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardCompanies> {
  late Widget mainWidget;
  late String titleWidget;
  late Company company;

  @override
  void initState() {
    mainWidget = widget.mainWidget;
    titleWidget = widget.titleWidget;
    company = widget.company;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeAdmin(
      mainWidget: mainWidget,
      titleWidget: titleWidget,
      company: company,
    );
  }
}

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({
    Key? key,
    required this.mainWidget,
    required this.titleWidget,
    required this.company,
  }) : super(key: key);

  final Widget mainWidget;
  final String titleWidget;
  final Company company;

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
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/");
                          },
                          child: Center(
                              child: Image.asset(
                            "assets/logo.png",
                            scale: 0.2,
                          )),
                        ),
                      ),
                    ),
                    DrawerListTile(
                      title: "Unités",
                      icon: Icons.apartment,
                      press: () {
                        Navigator.pushNamed(
                            context, 'company/${company.id}/units');
                      },
                    ),
                    DrawerListTile(
                      title: "Utilisateurs",
                      icon: Icons.group,
                      press: () {
                        Navigator.pushNamed(
                            context, 'company/${company.id}/users');
                      },
                    ),
                    DrawerListTile(
                      title: "Portes connectées",
                      icon: Icons.door_front_door,
                      press: () {
                        Navigator.pushNamed(
                            context, 'company/${company.id}/doors');
                      },
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Authentication.connectedUser?.role == Role.SuperAdmin
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          "dashboard/${Authentication.connectedUser?.id}/companies");
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: CustomTheme.colorTheme,
                                    ),
                                    label: Text('')),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            company.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 25.0, bottom: 10.0),
                          child: ProfileCard(),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15.0, bottom: 10.0),
                        child: Text(
                          titleWidget,
                          style: Theme.of(context).textTheme.headline4,
                        )),
                    mainWidget,
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
