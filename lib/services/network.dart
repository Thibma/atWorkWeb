import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/models/door.dart';
import 'package:my_office_desktop/models/door_status.dart';
import 'package:my_office_desktop/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/models/service.dart';
import 'package:my_office_desktop/models/unit.dart';

import 'dart:convert';

import 'package:my_office_desktop/models/user.dart';
import 'package:my_office_desktop/services/authentication.dart';
import 'package:my_office_desktop/services/place_api.dart';

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

  // Créer un user
  Future<ConnectedUser> createUser(String firstName, String lastName, String mail, Role role, String idFirebase, String idImage, Service service) async {
    try {
      final response = await http.post(Uri.parse("${address}users"),
          headers: apiTokenPost,
          body: jsonEncode(<String, dynamic>{
            'firstname': firstName,
            'lastname': lastName,
            'email': mail,
            'role': role.name,
            'idFirebase': idFirebase,
            'idImage': idImage,
            'services': service.id,
          }));

      try {
        return ConnectedUser.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir toutes les entreprises
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

  // Obtenir toutes les portes d'une entreprise
  Future<List<Door>> getCompanyDoors(String companyId) async {
    try {
      final response =
          await http.get(Uri.parse("${address}doors/company/$companyId"), headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Door> list = [];
        data.forEach((item) {
          list.add(Door.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les entreprises de l'utilisateur
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

  // Obtenir une company
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

  // Créer une entreprise
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

  Future<List<Unit>> getCompanyUnits(String companyId) async {
    try {
      final response = await http.get(
          Uri.parse("${address}units/company/$companyId"),
          headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Unit> list = [];
        data.forEach((item) {
          list.add(Unit.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Service>> getUnitService(String unitId) async {
    try {
      final response = await http.get(
          Uri.parse("${address}services/unit/$unitId"),
          headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Service> list = [];
        data.forEach((item) {
          list.add(Service.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Créer une unité
  Future<Unit> createUnit(String name, Place place, String companyId) async {
    try {
      final response = await http.post(Uri.parse("${address}units"),
          headers: apiTokenPost,
          body: jsonEncode(<String, dynamic>{
            'name': name,
            'latitude': place.latitude,
            'longitude': place.longitude,
            'altitude': 0,
            'company': companyId,
            'address': place.street
          }));

      try {
        return Unit.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Créer une unité
  Future<Door> createDoor(String tag, DoorStatus status, String unitId) async {
    try {
      final response = await http.post(Uri.parse("${address}doors"),
          headers: apiTokenPost,
          body: jsonEncode(<String, dynamic>{
            'tag': tag,
            'status': status.name,
            'unit': unitId,
          }));

      try {
        return Door.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ConnectedUser>> getCompanyUsers(String companyId) async {
    try {
      final response = await http.get(
          Uri.parse("${address}users/company/$companyId"),
          headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<ConnectedUser> list = [];
        data.forEach((item) {
          list.add(ConnectedUser.fromJson(item));
        });
        return list;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Suggestion>> getAutocompletePlaces(
      String input, String sessionToken) async {
    try {
      final response = await http.get(
          Uri.parse(
              "${address}firebase/place?input=$input&sessionToken=$sessionToken"),
          headers: apiToken);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final googleResponse = GoogleMapsResponsePrediction.fromJson(result);
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

      throw Exception('Failed to fetch suggestion');
    } catch (e) {
      rethrow;
    }
  }

  Future<Place> getDetailPlace(String placeId, String sessionToken) async {
    try {
      final response = await http.get(
          Uri.parse(
              "${address}firebase/placedetails?placeId=$placeId&sessionToken=$sessionToken"),
          headers: apiToken);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final googleResponse = GoogleMapsResponseDetail.fromJson(result);
          return Place.fromJson(googleResponse.result);
        }
      }

      throw Exception('Failed to fetch suggestion');
    } catch (e) {
      rethrow;
    }
  }
}
