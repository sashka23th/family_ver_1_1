// ignore_for_file: public_member_api_docs, sort_constructors_first
class TokenEntity {
  final bool success;
  final String token;
  final TokenMessageEntity message;

  TokenEntity({
    required this.success,
    required this.token,
    required this.message,
  });
}

class TokenMessageEntity {
  final String email;
  final String password;
  final String deviceName;

  TokenMessageEntity({
    required this.email,
    required this.password,
    required this.deviceName,
  });
}
