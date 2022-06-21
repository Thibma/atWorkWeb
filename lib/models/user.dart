import 'package:my_office_desktop/models/role.dart';

class ConnectedUser {
  final String id;
  final String idFirebase;
  final String idImage;
  final String firstname;
  final String lastname;
  final String email;
  final Role role;
  //final bool isHere;
  //final String? service;

  const ConnectedUser({
    required this.id,
    required this.idFirebase,
    required this.idImage,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    //required this.isHere,
    //required this.service
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      id: json["_id"],
      idFirebase: json["idFirebase"],
      idImage: json["idImage"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      role: Role.values.byName(json["role"]),
      //isHere: json["isHere"],
      //service: json["service"]
    );
  }
}
