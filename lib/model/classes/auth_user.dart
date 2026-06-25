import 'dart:convert';

class AuthUser {
  final int id;
  final String email;
  final String tokenAuth;
  final String dataHoraLogin;

  AuthUser({
    required this.id,
    required this.email,
    required this.tokenAuth,
    required this.dataHoraLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'tokenAuth': tokenAuth,
      'dataHoraLogin': dataHoraLogin,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] ?? 0,
      email: map['email'] ?? '',
      tokenAuth: map['tokenAuth'] ?? '',
      dataHoraLogin: map['dataHoraLogin'] ?? '',
    );
  }

  String encode() => json.encode(toMap());

  static AuthUser decode(String authUserJson) =>
      AuthUser.fromMap(json.decode(authUserJson) as Map<String, dynamic>);
}