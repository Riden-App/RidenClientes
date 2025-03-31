import 'dart:convert';

class GenerateCodeResponse {
  GenerateCodeResponse({
    required this.status,
    required this.data,
  });

  factory GenerateCodeResponse.fromRawJson(String str) =>
      GenerateCodeResponse.fromJson(json.decode(str));

  factory GenerateCodeResponse.fromJson(Map<String, dynamic> json) =>
      GenerateCodeResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );
  final String status;
  final Data data;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  Data({
    required this.idUser,
    required this.code,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json['idUser'],
        code: json['code'],
      );
  final int idUser;
  final String code;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'code': code,
      };
}
