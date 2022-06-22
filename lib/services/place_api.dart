import 'dart:convert';

import 'package:http/http.dart' as http;

class PlaceApiProvider {
  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  final apiKey = "AIzaSyCCJHHk0DpXZk5vtdgueQQbHls8xKA2-t8";

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    final request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=fr&key=$apiKey&sessiontoken=$sessionToken');
    try {
      final response = await http.get(request, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      });
      print(response);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print(result);
        if (result['status'] == 'OK') {
          final googleResponse = GoogleMapsResponse.fromJson(result);
          List<Suggestion> suggestions = [];
          googleResponse.predictions.forEach((element) {
            suggestions
                .add(Suggestion(element["place_id"], element["description"]));
          });
          return suggestions;
        }
        if (result['status'] == 'ZERO_RESULTS') {
          return [];
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch suggestion');
    }
    throw Exception('Failed to fetch suggestion');
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken');
    try {
      final response = await http.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final googleResponse = GoogleMapsResponse.fromJson(result);
        final place = Place.
      }
    }
    }
     catch(e) {
      throw Exception('Failed to fetch suggestion');
    }
    throw Exception('Failed to fetch suggestion');
  }
}

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
    return Place(street: "${json["address_componant"][0]["long_name"] +}", city: city, zipCode: zipCode, longitude: longitude, latitude: latitude)
  }

}
class GoogleMapsResponse {
  final List<dynamic> predictions;
  final String status;

  GoogleMapsResponse(this.predictions, this.status);

  factory GoogleMapsResponse.fromJson(Map<String, dynamic> json) {
    return GoogleMapsResponse(json["predictions"], json["status"]);
  }

  factory GoogleMapsResponse.fromJsonDetail(Map<String, dynamic> json) {
    return GoogleMapsResponse(json["result"], json["status"]);
  }
}
