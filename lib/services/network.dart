import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_office_desktop/models/company.dart';
import 'package:my_office_desktop/models/door.dart';
import 'package:my_office_desktop/models/door_status.dart';
import 'package:my_office_desktop/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_office_desktop/models/role.dart';
import 'package:my_office_desktop/models/service.dart';
import 'package:my_office_desktop/models/ticket.dart';
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

  final Map<String, String> apiTokenOnlyPost = {
    "api-token": "urHkArjloX6kRrNJOrUCIOi8N2tZbRu8",
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

  // SignIn
  Future<ConnectedUser?> getUserByMail(String email) async {
    try {
      final response = await http.get(Uri.parse("${address}users/email/$email"),
          headers: apiToken);

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
  Future<ConnectedUser> createUser(
      String firstName,
      String lastName,
      String mail,
      Role role,
      String idFirebase,
      String idImage,
      Service service) async {
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

  Future<ConnectedUser> editUser(String? firstName, String? lastName,
      Role? role, Service? service, String idUser) async {
    Map<String, dynamic> body = {};

    if (firstName != null) {
      body["firstname"] = firstName;
    }
    if (lastName != null) {
      body["lastname"] = firstName;
    }
    if (role != null) {
      body["role"] = role.name;
    }
    if (service != null) {
      body["services"] = service.id;
    }
    try {
      final response = await http.put(Uri.parse("${address}users/$idUser"),
          headers: apiTokenPost, body: jsonEncode(body));

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

  // Obtenir tous les tickets
  Future<List<Ticket>> getAllTickets() async {
    try {
      final response =
          await http.get(Uri.parse("${address}tickets"), headers: apiToken);

      try {
        var data = apiResponse(response).content;
        List<Ticket> list = [];
        data.forEach((item) {
          list.add(Ticket.fromJson(item));
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
      final response = await http.get(
          Uri.parse("${address}doors/company/$companyId"),
          headers: apiToken);

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

  // Créer un service
  Future<Service> createService(String name, String idUnit) async {
    try {
      final response = await http.post(Uri.parse("${address}services"),
          headers: apiTokenPost,
          body: jsonEncode(<String, String>{
            'name': name,
            'unit': idUnit,
          }));

      try {
        return Service.fromJson(apiResponse(response).content);
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
      final response = await http
          .get(Uri.parse("${address}services/unit/$unitId"), headers: apiToken);

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

  // Modifier une unité
  Future<Unit> editUnit(String unitId, String? name, Place? place) async {
    Map<String, dynamic> body = {};
    if (name != null) {
      body["name"] = name;
    }
    if (place != null) {
      body["latitude"] = place.latitude;
      body["longitude"] = place.longitude;
      body["address"] = place.street;
    }
    try {
      final response = await http.put(Uri.parse("${address}units/$unitId"),
          headers: apiTokenPost, body: jsonEncode(body));

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

  Future<Door> editDoor(
      String? tag, DoorStatus? status, String? unitId, String doorId) async {
    Map<String, dynamic> body = {};
    if (tag != null) {
      body["tag"] = tag;
    }
    if (status != null) {
      body["status"] = status.name;
    }
    if (unitId != null) {
      body["unit"] = unitId;
    }
    try {
      final response = await http.put(Uri.parse("${address}doors/$doorId"),
          headers: apiTokenPost, body: jsonEncode(body));

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

  Future<List<ConnectedUser>> getUnitsUsers(String unitId) async {
    try {
      final response = await http.get(Uri.parse("${address}users/unit/$unitId"),
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

  Future<bool> deleteService(String idService) async {
    try {
      final response = await http.delete(
          Uri.parse("${address}services/$idService"),
          headers: apiToken);

      try {
        return apiResponse(response).content;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteDoor(String idDoor) async {
    try {
      final response = await http.delete(Uri.parse("${address}doors/$idDoor"),
          headers: apiToken);

      try {
        return apiResponse(response).content;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteUser(String idUser, String idFirebase) async {
    try {
      final response = await http.delete(Uri.parse("${address}users/$idUser"),
          headers: apiToken);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(idFirebase)
          .delete();

      try {
        return apiResponse(response).content;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteUnit(String idUnit) async {
    try {
      final List<ConnectedUser> userList = await getUnitsUsers(idUnit);

      if (userList.isNotEmpty) {
        throw ("Impossible de supprimer la liste, il faut qu'il n'y ai plus un seul collaborateur pour supprimer l'unité.");
      }

      final response = await http.delete(Uri.parse("${address}units/$idUnit"),
          headers: apiToken);

      try {
        return apiResponse(response).content;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Créer un service
  Future<Ticket> createTicket(String creator, String description) async {
    try {
      final response = await http.post(Uri.parse("${address}tickets"),
          headers: apiTokenOnlyPost,
          body: jsonEncode(<String, String>{
            'creator': creator,
            'description': description,
            'status': TicketStatus.Waiting.name
          }));

      try {
        return Ticket.fromJson(apiResponse(response).content);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Door> editTicket(TicketStatus ticketStatus, String ticketId) async {
    try {
      final response = await http.put(Uri.parse("${address}tickets/$ticketId"),
          headers: apiTokenPost, body: jsonEncode(<String, String> {
            'status': ticketStatus.name
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

}
