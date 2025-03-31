import 'dart:convert';

class LocationResponse {
  final String status;
  final DataLocationResponse data;

  LocationResponse({
    required this.status,
    required this.data,
  });


  factory LocationResponse.fromRawJson(String str) =>
      LocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      LocationResponse(
        status: json['status'],
        data: DataLocationResponse.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataLocationResponse {
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final List<String> userRoles;
  final double ratingAveragePassenger;
  final double ratingAverageDriver;

  DataLocationResponse({
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
  });

  factory DataLocationResponse.fromRawJson(String str) =>
      DataLocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataLocationResponse.fromJson(Map<String, dynamic> json) =>
      DataLocationResponse(
        id: json['id'],
        mobile: json['mobile'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userRoles: List<String>.from(json['userRoles'].map((x) => x)),
        ratingAveragePassenger:
            double.parse(json['ratingAveragePassenger'].toString()) ?? 0,
        ratingAverageDriver:
            double.parse(json['ratingAverageDriver'].toString()) ?? 0,
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
      };
}
