import 'dart:convert';

class InfoUserReferredResponse {
    final String status;
    final Data data;

    InfoUserReferredResponse({
        required this.status,
        required this.data,
    });

    factory InfoUserReferredResponse.fromRawJson(String str) => InfoUserReferredResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InfoUserReferredResponse.fromJson(Map<String, dynamic> json) => InfoUserReferredResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    final int idUser;
    final dynamic code;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic deletedAt;

    Data({
        required this.idUser,
        required this.code,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["idUser"],
        code: json["code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "code": code,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
