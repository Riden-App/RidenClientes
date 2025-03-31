import '../enums/enums.dart';

class UserData {
  UserData({
    required this.idToken,
    required this.pnToken,
    required this.mobile,
    this.email,
    this.firstName,
    this.lastName,
    required this.role,
    required this.authType,
  });
  final String idToken;
  final String pnToken;
  final String mobile;
  final String? email;
  final String? firstName;
  final String? lastName;
  final UserRole role;
  final AuthType authType;

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'pnToken': pnToken,
      'mobile': mobile,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.value,
      'authType': authType.value,
    };
  }

  @override
  String toString() {
    return 'UserData{idToken: $idToken, pnToken: $pnToken, mobile: $mobile, email: $email, firstName: $firstName, lastName: $lastName, role: ${role.value}, authType: ${authType.value}}';
  }
}
