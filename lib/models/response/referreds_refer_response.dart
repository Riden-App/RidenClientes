import 'dart:convert';

class ReferredsReferResponse {

    ReferredsReferResponse({
        required this.status,
        required this.data,
    });

    factory ReferredsReferResponse.fromRawJson(String str) => ReferredsReferResponse.fromJson(json.decode(str));

    factory ReferredsReferResponse.fromJson(Map<String, dynamic> json) => ReferredsReferResponse(
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
        required this.idUserReferred,
        required this.percentage,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json['idUser'],
        idUserReferred: json['idUserReferred'],
        percentage: json['percentage'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'],
    );
    final int idUser;
    final int idUserReferred;
    final String percentage;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic deletedAt;

    String toRawJson() => json.encode(toJson());

    Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idUserReferred': idUserReferred,
        'percentage': percentage,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt,
    };
}
