import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

class DashboardAdminPage extends StatefulWidget {
  DashboardAdminPage({Key? key}) : super(key: key);

  @override
  _DashboardAdminPage createState() => _DashboardAdminPage();
}

class _DashboardAdminPage extends State<DashboardAdminPage> {
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
                      press: () {},
                    ),
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
                //padding: EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 25.0, bottom: 10.0),
                            child: Text(
                              "Liste des entreprises",
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
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: CustomTheme.colorTheme,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [Text("Bonjour")],
                      ),
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

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key, required this.title, required this.icon, required this.press})
      : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: Icon(icon),
      title: Text(title),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print("hello");
        },
        child: Container(
          margin: EdgeInsets.only(left: 16.0),
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0 / 2,
          ),
          decoration: BoxDecoration(
            color: CustomTheme.colorTheme,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16 / 2),
                child: Text(
                  "Thibma",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
