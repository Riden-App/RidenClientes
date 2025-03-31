import 'dart:convert';

class UserResponse {
  final String status;
  final DataUser data;

  UserResponse({
    required this.status,
    required this.data,
  });

  factory UserResponse.fromRawJson(String str) =>
      UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json['status'],
        data: DataUser.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class DataUser {
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final List<String> userRoles;
  final int ratingAveragePassenger;
  final int ratingAverageDriver;
  final dynamic profilePictureUrl;

  DataUser({
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

  factory DataUser.fromRawJson(String str) => DataUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json['id'],
        mobile: json['mobile'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        userRoles: List<String>.from(json['userRoles'].map((x) => x)),
        ratingAveragePassenger: json['ratingAveragePassenger'],
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
