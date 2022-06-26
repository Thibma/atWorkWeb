class Service {
  final String name;
  final String id;

  Service({required this.name, required this.id});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(name: json['name'], id: json['_id']);
  }
}
