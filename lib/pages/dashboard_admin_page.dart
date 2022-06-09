import 'package:flutter/material.dart';

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
                        child: Text(
                          "At Work - Admin",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                      Text(
                        "Liste des entreprises",
                        style: Theme.of(context).textTheme.headline6,
                      )
                    ],
                  ),
                ],
              )),
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
