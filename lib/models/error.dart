class Error {
  final String error;
  final String criticity;

  const Error({required this.error, required this.criticity});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(error: json["error"], criticity: json["severity"]);
  }
}
