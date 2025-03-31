import 'dart:convert';

class UpdateProfileResponse {
  UpdateProfileResponse({
    required this.status,
    required this.data,
  });

  factory UpdateProfileResponse.fromRawJson(String str) =>
      UpdateProfileResponse.fromJson(json.decode(str));

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
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
    required this.id,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.ratingAveragePassenger,
    required this.ratingAverageDriver,
    required this.profilePictureUrl,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] ?? 0,
        mobile: json['mobile'] ?? '',
        email: json['email'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        latitude: json['latitude'] ?? '',
        longitude: json['longitude'] ?? '',
        ratingAveragePassenger: json['ratingAveragePassenger'] ?? 0,
        ratingAverageDriver: json['ratingAverageDriver'] ?? 0,
        profilePictureUrl: json['profilePictureUrl'] ?? '',
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic ratingAveragePassenger;
  final dynamic ratingAverageDriver;
  final dynamic profilePictureUrl;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'latitude': latitude,
        'longitude': longitude,
        'ratingAveragePassenger': ratingAveragePassenger,
        'ratingAverageDriver': ratingAverageDriver,
        'profilePictureUrl': profilePictureUrl,
      };
}
