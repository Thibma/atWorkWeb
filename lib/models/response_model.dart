class ResponseModel {
  final dynamic message;
  final bool error;

  const ResponseModel({
    required this.message,
    required this.error,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'],
      error: json['error'],
    );
  }
}
