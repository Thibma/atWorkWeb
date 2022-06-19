import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/widgets/drawer_list.dart';
import 'package:my_office_desktop/pages/widgets/profile_card.dart';

import '../services/authentication.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return HomeAdmin();
  }
}

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({Key? key}) : super(key: key);

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
                      press: () {},
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
                              "titleWidget",
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
                    //mainWidget,
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