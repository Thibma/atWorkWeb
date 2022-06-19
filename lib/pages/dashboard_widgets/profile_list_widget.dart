import 'package:flutter/material.dart';

class ProfileListWidget extends StatefulWidget {
  const ProfileListWidget({Key? key}) : super(key: key);

  @override
  State<ProfileListWidget> createState() => _ProfileListWidgetState();
}

class _ProfileListWidgetState extends State<ProfileListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Page de Profil"),);
  }
}