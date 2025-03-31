import 'dart:convert';

class ReferredsUserReferredResponse {
  final String status;
  final List<DataReferreds> data;

  ReferredsUserReferredResponse({
    required this.status,
    required this.data,
  });

  factory ReferredsUserReferredResponse.fromRawJson(String str) =>
      ReferredsUserReferredResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferredsUserReferredResponse.fromJson(Map<String, dynamic> json) =>
      ReferredsUserReferredResponse(
        status: json['status'],
        data: List<DataReferreds>.from(json['data'].map((x) => DataReferreds.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataReferreds {
  final int idUser;
  final int idUserReferred;
  final String percentage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final num totalAmount;
  final num transactionCount;

  DataReferreds({
    required this.idUser,
    required this.idUserReferred,
    required this.percentage,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.totalAmount,
    required this.transactionCount,

  });

  factory DataReferreds.fromRawJson(String str) => DataReferreds.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataReferreds.fromJson(Map<String, dynamic> json) => DataReferreds(
        idUser: json['idUser'],
        idUserReferred: json['idUserReferred'],
        percentage: json['percentage'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'],
        totalAmount: json['totalAmount'],
        transactionCount: json['transactionCount'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idUserReferred': idUserReferred,
        'percentage': percentage,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt,
        'totalAmount': totalAmount,
        'transactionCount': transactionCount,
      };
}
