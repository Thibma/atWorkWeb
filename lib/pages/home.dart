import 'package:flutter/material.dart';

import '../theme.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/web/background.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/logo_home.png",
                        scale: 2,
                      ),
                      SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CustomTheme.colorTheme),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          child: Text(
                            "Dashboard",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 250),
                            child: Text(
                              "La nouvelle application\npour entreprise !",
                              style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 250),
                            child: Text(
                              "Restez proches, même de loin !\nAu bureau comme en télétravail, supprimons les barrières en entreprise !\nAvec At Work, retrouvez en une seule application tous vos outils du quotidien !\nVoici quelques fonctionalités :",
                              style: TextStyle(
                                  color: CustomTheme.colorTheme, fontSize: 16),
                              maxLines: 10,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 260),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " • ",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 20),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Messagerie instantanée",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 16),
                                  ))
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 260),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " • ",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 20),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Localisation en fonction de votre entreprise",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 16),
                                  ))
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 260),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " • ",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 20),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Agendas syncronisés",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 16),
                                  ))
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 260),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " • ",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 20),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Badges électroniques intégrés",
                                    style: TextStyle(
                                        color: CustomTheme.colorTheme,
                                        fontSize: 16),
                                  ))
                                ]),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 80,
                              width: 400,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CustomTheme.colorTheme),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                                child: Text(
                                  "Inscrivez-vous !",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            "assets/web/screen.jpg",
                            scale: 3,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
