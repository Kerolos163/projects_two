class ForgetPasswordResponse {
  final String status;
  final String message;
  final Data data;
  ForgetPasswordResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgetPasswordResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final String resetCode;

  Data({required this.resetCode});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(resetCode: json["resetCode"]);

  Map<String, dynamic> toJson() => {"resetCode": resetCode};
}
