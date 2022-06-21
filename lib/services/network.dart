import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/models/response_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:my_office_desktop/models/user.dart';
import 'package:my_office_desktop/services/authentication.dart';

class Network {
  // Adresse API
  //final String address = "http://10.33.3.78:8000";
  final String address = "http://vps-e96550d9.vps.ovh.net:8082/";

  final Map<String, String> apiToken = {
    "api-token": "urHkArjloX6kRrNJOrUCIOi8N2tZbRu8",
    "firebase": Authentication.getFirebaseUser()!.uid
  };

  final Map<String, String> apiTokenPost = {
    "api-token": "urHkArjloX6kRrNJOrUCIOi8N2tZbRu8",
    "firebase": Authentication.getFirebaseUser()!.uid,
    "Content-Type": "application/json"
  };

  final Map<String, String> apiTokenOnly = {
    "api-token": "urHkArjloX6kRrNJOrUCIOi8N2tZbRu8"
  };

  ResponseModel apiResponse(http.Response response) {
    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 202 || response.statusCode == 400) {
      if (responseModel.errors.isNotEmpty) {
        print(responseModel.errors[0].error);
        throw (responseModel.errors[0].error);
      }

      return responseModel;
    } else {
      print(responseModel.errors[0].error);
      throw (responseModel.errors[0].error);
    }
  }

  // SignIn
  Future<ConnectedUser?> login(String email) async {
    try {
      final response = await http
          .get(Uri.parse("${address}users/signin/$email"), headers: apiToken);

      try {
        return ConnectedUser.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Company>> getAllCompany() async {
    try {
      final response =
          await http.get(Uri.parse("${address}company"), headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Company> list = [];
        data.forEach((item) {
          list.add(Company.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Company>> getUserCompanies(String userId) async {
    try {
      final response = await http
          .get(Uri.parse("${address}company/user/$userId"), headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Company> list = [];
        data.forEach((item) {
          list.add(Company.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Company> getCompany(String companyId) async {
    try {
      final response = await http.get(Uri.parse("${address}company/$companyId"),
          headers: apiToken);

      try {
        return Company.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Company> createCompany(String name, String image) async {
    try {
      final response = await http.post(Uri.parse("${address}company"),
          headers: apiTokenPost,
          body: jsonEncode(<String, String>{
            'name': name,
            'image': image,
          }));

      try {
        return Company.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
