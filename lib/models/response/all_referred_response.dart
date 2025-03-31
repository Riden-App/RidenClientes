import 'dart:convert';

class AllReferedResponse {
    final String status;
    final Data data;

    AllReferedResponse({
        required this.status,
        required this.data,
    });

    factory AllReferedResponse.fromRawJson(String str) => AllReferedResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllReferedResponse.fromJson(Map<String, dynamic> json) => AllReferedResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    final List<Referred> referreds;
    final int countIdUserWithoutTripCompleted;
    final List<Referred> userWithoutTripCompleted;
    final int countIdUserWithTripCompleted;
    final TotalAmount totalAmount;

    Data({
        required this.referreds,
        required this.countIdUserWithoutTripCompleted,
        required this.userWithoutTripCompleted,
        required this.countIdUserWithTripCompleted,
        required this.totalAmount,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        referreds: List<Referred>.from(json['referreds'].map((x) => Referred.fromJson(x))),
        countIdUserWithoutTripCompleted: json['countIdUserWithoutTripCompleted'],
        userWithoutTripCompleted: List<Referred>.from(json['userWithoutTripCompleted'].map((x) => Referred.fromJson(x))),
        countIdUserWithTripCompleted: json['countIdUserWithTripCompleted'],
        totalAmount: TotalAmount.fromJson(json['totalAmount']),
    );

    Map<String, dynamic> toJson() => {
        'referreds': List<dynamic>.from(referreds.map((x) => x.toJson())),
        'countIdUserWithoutTripCompleted': countIdUserWithoutTripCompleted,
        'userWithoutTripCompleted': List<dynamic>.from(userWithoutTripCompleted.map((x) => x.toJson())),
        'countIdUserWithTripCompleted': countIdUserWithTripCompleted,
        'totalAmount': totalAmount.toJson(),
    };
}

class Referred {
    final dynamic idUser;
    final dynamic idUserReferred;
    final dynamic percentage;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic deletedAt;

    Referred({
        required this.idUser,
        required this.idUserReferred,
        required this.percentage,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Referred.fromRawJson(String str) => Referred.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Referred.fromJson(Map<String, dynamic> json) => Referred(
        idUser: json['idUser'],
        idUserReferred: json['idUserReferred'],
        percentage: json['percentage'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'],
    );

    Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idUserReferred': idUserReferred,
        'percentage': percentage,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt,
    };
}

class TotalAmount {
    final String totalAmount;

    TotalAmount({
        required this.totalAmount,
    });

    factory TotalAmount.fromRawJson(String str) => TotalAmount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TotalAmount.fromJson(Map<String, dynamic> json) => TotalAmount(
        totalAmount: json['totalAmount'],
    );

    Map<String, dynamic> toJson() => {
        'totalAmount': totalAmount,
    };
}
