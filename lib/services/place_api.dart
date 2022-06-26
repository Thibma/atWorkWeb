class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(json["place_id"], json["description"]);
  }
}

class Place {
  String street;
  String city;
  String zipCode;
  double longitude;
  double latitude;

  Place({
    required this.street,
    required this.city,
    required this.zipCode,
    required this.longitude,
    required this.latitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        street:
            "${json["address_components"][0]["long_name"]} ${json["address_components"][1]["long_name"]}",
        city: json["address_components"][2]["long_name"],
        zipCode: json["address_components"][6]["long_name"],
        longitude: json["geometry"]["location"]["lng"],
        latitude: json["geometry"]["location"]["lat"]);
  }
}

class GoogleMapsResponsePrediction {
  final List<dynamic> predictions;
  final String status;

  GoogleMapsResponsePrediction(this.predictions, this.status);

  factory GoogleMapsResponsePrediction.fromJson(Map<String, dynamic> json) {
    return GoogleMapsResponsePrediction(json["predictions"], json["status"]);
  }
}

class GoogleMapsResponseDetail {
  final Map<String, dynamic> result;
  final String status;

  GoogleMapsResponseDetail(this.result, this.status);

  factory GoogleMapsResponseDetail.fromJson(Map<String, dynamic> json) {
    return GoogleMapsResponseDetail(json["result"], json["status"]);
  }
}
