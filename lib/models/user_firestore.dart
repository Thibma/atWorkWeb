import '../utils/utils.dart';

class UserFirestoreField {
  static String lastMessageTime = 'lastMessageTime';
}

class UserFirestore {
  final String? idUser;
  final String? name;
  final DateTime? lastMessageTime;

  const UserFirestore.userFirebase({
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
      UserFirestore.userFirebase(
        idUser: idUser,
        name: name ?? this.name,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static UserFirestore fromJson(Map<String, dynamic> json) =>
      UserFirestore.userFirebase(
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
