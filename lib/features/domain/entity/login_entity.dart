import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String deviceName;
  final String password;
  final String email;

  const LoginEntity(
      {required this.deviceName, required this.password, required this.email});

  @override
  List<Object> get props => [email, password, deviceName];

  Map<String, dynamic> toJson() {
    return {
      'device_name': deviceName,
      'password': password,
      'email': email,
    };
  }
}
