import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

import '../../models/unit.dart';

class UnitCard extends StatelessWidget {
  const UnitCard({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'company/${unit.id}/units');
      },
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
              Icons.apartment,
              size: 80,
              color: Colors.white,
            ),
            Text(
              unit.name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
