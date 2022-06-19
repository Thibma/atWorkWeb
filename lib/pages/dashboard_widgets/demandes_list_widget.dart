import 'package:flutter/material.dart';

class DemandesListWidget extends StatefulWidget {
  const DemandesListWidget({Key? key}) : super(key: key);

  @override
  State<DemandesListWidget> createState() => _DemandesListWidgetState();
}

class _DemandesListWidgetState extends State<DemandesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Page de demandes"),);
  }
}