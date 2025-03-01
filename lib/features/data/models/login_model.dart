import 'package:family_cash/features/domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel(
      {required super.deviceName,
      required super.password,
      required super.email});

  // Метод для преобразования объекта User в JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceName': deviceName,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json.containsKey('email') ? json['email'][0] : '',
      password: json.containsKey('password') ? json['password'][0] : '',
      deviceName: json.containsKey('device_name') ? json['device_name'][0] : '',
    );
  }
}
