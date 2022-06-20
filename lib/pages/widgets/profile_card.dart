import 'package:flutter/material.dart';
import 'package:my_office_desktop/services/authentication.dart';

import '../../theme.dart';

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
                  "${Authentication.connectedUser?.firstname} ${Authentication.connectedUser?.lastname}",
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
