import 'dart:convert';

class InfoUserReponse {
    final String status;
    final Data data;

    InfoUserReponse({
        required this.status,
        required this.data,
    });

    factory InfoUserReponse.fromRawJson(String str) => InfoUserReponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InfoUserReponse.fromJson(Map<String, dynamic> json) => InfoUserReponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
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

    Data({
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

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mobile: json["mobile"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userRoles: List<String>.from(json["userRoles"].map((x) => x)),
        ratingAveragePassenger: json["ratingAveragePassenger"],
        ratingAverageDriver: json["ratingAverageDriver"],
        profilePictureUrl: json["profilePictureUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mobile": mobile,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "latitude": latitude,
        "longitude": longitude,
        "userRoles": List<dynamic>.from(userRoles.map((x) => x)),
        "ratingAveragePassenger": ratingAveragePassenger,
        "ratingAverageDriver": ratingAverageDriver,
        "profilePictureUrl": profilePictureUrl,
    };
}
