import 'package:flutter/material.dart';

class UnitsListWidget extends StatefulWidget {
  const UnitsListWidget({Key? key}) : super(key: key);

  @override
  State<UnitsListWidget> createState() => _ProfiUnitsidgetState();
}

class _ProfiUnitsidgetState extends State<UnitsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Liste des unités"),
    );
  }
}
