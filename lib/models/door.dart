import 'package:my_office_desktop/models/door_status.dart';
import 'package:my_office_desktop/models/unit.dart';

class Door {
  final String id;
  final DoorStatus status;
  final String tag;
  final Unit unit;
  final String url;

  Door({
    required this.id,
    required this.status,
    required this.tag,
    required this.unit,
    required this.url,
  });

  factory Door.fromJson(Map<String, dynamic> json) {
    return Door(id: json['_id'], status: DoorStatus.values.byName(json['status']), tag: json['tag'], unit: Unit.fromJson(json['unit']), url: json['url']);
  }
}
