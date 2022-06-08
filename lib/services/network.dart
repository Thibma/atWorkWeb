import 'package:my_office_desktop/models/response_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:my_office_desktop/models/user.dart';

class Network {
  // Adresse API
  final String address = "http://10.33.3.78:8000";

  final Map<String, String> apiToken = {"api-token": "test"};

  ResponseModel apiResponse(http.Response response) {
    if (response.statusCode == 202 || response.statusCode == 400) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.body));
      if (responseModel.error) {
        throw (responseModel.message);
      }

      return responseModel;
    } else {
      throw (response.body);
    }
  }

  // SignIn
  Future<ConnectedUser> login(String uid) async {
    try {
      final response = await http
          .get(Uri.parse(address + "/users/firebase/$uid"), headers: apiToken);

      try {
        return ConnectedUser.fromJson(apiResponse(response).message);
      } catch (e) {
        throw (apiResponse(response).message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
