import 'package:meta/meta.dart';

import '../utils/utils.dart';

class UserFirestoreField {
  static final String lastMessageTime = 'lastMessageTime';
}

class UserFirestore {
  final String? idUser;
  final String? name;
  final DateTime? lastMessageTime;

  const UserFirestore.UserFirebase({
    this.idUser,
    this.name,
    this.lastMessageTime,
  });

  UserFirestore copyWith({
    required String idUser,
    String? name,
    String? urlAvatar,
    DateTime? lastMessageTime,
  }) =>
      UserFirestore.UserFirebase(
        idUser: idUser,
        name: name ?? this.name,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static UserFirestore fromJson(Map<String, dynamic> json) =>
      UserFirestore.UserFirebase(
        idUser: json['idUser'],
        name: json['name'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
