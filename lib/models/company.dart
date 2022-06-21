class Company {
  final String name;
  final String id;
  final String? image;

  const Company({required this.name, required this.id, this.image});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(name: json['name'], id: json["_id"], image: json["image"]);
  }
}
