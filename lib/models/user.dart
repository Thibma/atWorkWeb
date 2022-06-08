class ConnectedUser {
  final String idFirebase;
  final String firstname;
  final String lastname;
  final String email;
  final bool isHere;
  //final Role role;

  const ConnectedUser(
      {required this.idFirebase,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.isHere});

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
        idFirebase: json["idFirebase"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        isHere: json["isHere"]);
  }
}
