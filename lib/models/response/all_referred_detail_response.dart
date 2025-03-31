import 'dart:convert';

class AllReferedDetailResponse {
  final String status;
  final List<DataReferred> data;

  AllReferedDetailResponse({
    required this.status,
    required this.data,
  });

  factory AllReferedDetailResponse.fromRawJson(String str) =>
      AllReferedDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllReferedDetailResponse.fromJson(Map<String, dynamic> json) =>
      AllReferedDetailResponse(
        status: json['status'],
        data: List<DataReferred>.from(json['data'].map((x) => DataReferred.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataReferred {
  final Referred referred;
  final DateTime referredDate;
  final String totalAmount;
  final int totalCount;

  DataReferred({
    required this.referred,
    required this.referredDate,
    required this.totalAmount,
    required this.totalCount,
  });

  factory DataReferred.fromRawJson(String str) => DataReferred.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataReferred.fromJson(Map<String, dynamic> json) => DataReferred(
        referred: Referred.fromJson(json['referred']),
        referredDate: DateTime.parse(json['referredDate']),
        totalAmount: json['totalAmount'],
        totalCount: json['totalCount'],
      );

  Map<String, dynamic> toJson() => {
        'referred': referred.toJson(),
        'referredDate': referredDate.toIso8601String(),
        'totalAmount': totalAmount,
        'totalCount': totalCount,
      };
}

class Referred {
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final List<String> userRoles;
  final double ratingAveragePassenger;
  final int ratingAverageDriver;
  final dynamic profilePictureUrl;

  Referred({
    required this.id,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.userRoles,
    required this.ratingAveragePassenger,
    required this.ratingAverageDriver,
    required this.profilePictureUrl,
  });

  factory Referred.fromRawJson(String str) =>
      Referred.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Referred.fromJson(Map<String, dynamic> json) => Referred(
        id: json['id'],
        mobile: json['mobile'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userRoles: List<String>.from(json['userRoles'].map((x) => x)),
        ratingAveragePassenger: json['ratingAveragePassenger']?.toDouble(),
        ratingAverageDriver: json['ratingAverageDriver'],
        profilePictureUrl: json['profilePictureUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'latitude': latitude,
        'longitude': longitude,
        'userRoles': List<dynamic>.from(userRoles.map((x) => x)),
        'ratingAveragePassenger': ratingAveragePassenger,
        'ratingAverageDriver': ratingAverageDriver,
        'profilePictureUrl': profilePictureUrl,
      };
}
