import 'package:family_cash/features/domain/entity/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({required super.id, required super.name});

// Фабричный метод для создания объекта  из JSON
  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      name: json['name'],
    );
  }

  // Метод для преобразования объекта  в JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Для преобразования в строку и обратно (для shared preferences)
  String toStringFormat() => '$id,$name';

  static FamilyModel fromString(String str) {
    final parts = str.split(',');
    return FamilyModel(id: int.parse(parts[0]), name: parts[1]);
  }
}
