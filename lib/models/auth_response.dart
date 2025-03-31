class AuthResponse {
  final String status;
  final BodyResponse data;

  AuthResponse({required this.status, required this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'],
      data: BodyResponse.fromJson(json['data']),
    );
  }
}

class BodyResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  BodyResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory BodyResponse.fromJson(Map<String, dynamic> json) {
    return BodyResponse(
      user: User.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

class User {
  final int id;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic latitude;
  final dynamic longitude;
  final List<String> userRoles;

  User({
    required this.id,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.userRoles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      mobile: json['mobile'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      userRoles: json['userRoles'] != null ? List<String>.from(json['userRoles']) : [],
    );
  }
}
