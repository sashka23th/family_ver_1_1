import 'package:family_cash/features/domain/entity/user_enity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.registrationDate,
    required super.id,
    required super.name,
    required super.email,
  });

  // Фабричный метод для создания объекта User из JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      registrationDate: DateTime.parse(json['created_at']),
    );
  }

  // Метод для преобразования объекта User в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': registrationDate.toIso8601String()
    };
  }
}
