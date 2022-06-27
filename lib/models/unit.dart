class Unit {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double altitude;
  //final String idCompany;
  final String address;

  Unit(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.address,});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
        id: json["_id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        altitude: json["altitude"],
        address: json["address"]);
  }
}
