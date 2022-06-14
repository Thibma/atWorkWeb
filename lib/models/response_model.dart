import 'package:my_office_desktop/models/error.dart';

class ResponseModel {
  final dynamic content;
  final List<Error> errors;

  const ResponseModel({
    required this.content,
    required this.errors,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    var value = json['content'];
    var error = json['errors'];
    List<Error> list = [];
    error.forEach((item) {
      list.add(Error.fromJson(item));
    });
    return ResponseModel(
      content: value['value'],
      errors: list,
    );
  }
}
