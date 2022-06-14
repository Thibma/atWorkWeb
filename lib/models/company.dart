class Company {
  final String name;
  final String id;

  const Company({required this.name, required this.id});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(name: json['name'], id: json["_id"]);
  }
}
