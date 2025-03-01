import 'package:family_cash/features/domain/entity/token_entity.dart';

class TokenModel extends TokenEntity {
  @override
  // ignore: overridden_fields
  final TokenMessageModel message;

  TokenModel({
    required this.message,
    required super.success,
    required super.token,
  }) : super(message: message);

  // Фабричный метод для создания объекта Family из JSON
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      success: json['success'],
      token: json['token'] ?? '',
      message: json['message'] != null
          ? TokenMessageModel.fromJson(json['message'])
          : TokenMessageModel(email: '', password: '', deviceName: ''),
    );
  }

  // // Метод для преобразования объекта User в JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'message': message,
    };
  }
}

class TokenMessageModel extends TokenMessageEntity {
  TokenMessageModel(
      {required super.email,
      required super.password,
      required super.deviceName});

  factory TokenMessageModel.fromJson(Map<String, dynamic> json) {
    return TokenMessageModel(
      email: json.containsKey('email') ? json['email'][0] : '',
      password: json.containsKey('password') ? json['password'][0] : '',
      deviceName: json.containsKey('device_name') ? json['device_name'][0] : '',
    );
  }

  // Метод для преобразования объекта Family в JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceName': deviceName,
    };
  }
}
