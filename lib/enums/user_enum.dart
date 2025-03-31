enum UserRole {
  passenger('passenger'),
  driver('driver');

  final String value;
  const UserRole(this.value);
}

enum AuthType {
  mobile('mobile'),
  google('google'),
  facebook('facebook');

  final String value;
  const AuthType(this.value);
}

enum TokenProvider{
  firebase('firebase'),
  rideit('rideit');

  final String value;
  const TokenProvider(this.value);
}
