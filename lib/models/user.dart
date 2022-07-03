import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/models/service.dart';

class ConnectedUser {
  final String id;
  final String idFirebase;
  final String idImage;
  final String firstname;
  final String lastname;
  final String email;
  final Role role;
  final List<Service> services;
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
    required this.services,
    //required this.isHere,
    //required this.service
  });

  String serviceNames() {
    String result = "";

    for (var element in services) {
      result += "${element.name} ";
    }

    return result == "" ? "Aucun services" : result;
  }

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    List<Service> resultServices = [];
    var resultData = json["services"];
    resultData.forEach((element) {
      resultServices.add(Service.fromJson(element));
    });
    return ConnectedUser(
      id: json["_id"],
      idFirebase: json["idFirebase"],
      idImage: json["idImage"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      role: Role.values.byName(json["role"]),
      services: resultServices,
      //isHere: json["isHere"],
      //service: json["service"]
    );
  }
}
