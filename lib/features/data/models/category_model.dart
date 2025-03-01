import 'package:flutter/material.dart';
import 'package:family_cash/features/data/datasources/local/icon_list.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel(
      {super.createdAt,
      required super.id,
      required super.familyId,
      required super.name,
      required super.prefix,
      required super.details,
      required super.iconColor,
      required super.icon});

// Фабричный метод для создания объекта Category из JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      createdAt: json.containsKey('created_at')
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      familyId: json['family_id'],
      prefix: parsePrefix(json['prefix']),
      details: json['details'],
      iconColor: _hexToColor(json['icon_color']),
      icon: _getIconData(json['icon_name']),
    );
  }

  // Метод для преобразования объекта Category в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      //'created_at': createdAt.toIso8601String(),
      'family_id': familyId,
      'prefix': prefix.name,
      'icon_name': _findKeyByIcon(icon),
      'icon_color': _colorToHex(iconColor),
      'details': details,
    };
  }
}

String _findKeyByIcon(IconData targetIcon) {
  for (var entry in iconMapping.entries) {
    if (entry.value == targetIcon) {
      return entry.key;
    }
  }
  return ''; // возвращаем null, если совпадение не найдено
}

// Функция, которая возвращает IconData по имени из словаря
IconData _getIconData(String iconName) {
  return iconMapping[iconName] ??
      Icons.help_outline; // fallback на случай, если имя иконки не найдено
}

/// Преобразует строку HEX (например, `#FF5733`) в объект `Color`
Color _hexToColor(String hex) {
  hex = hex.replaceFirst('#', ''); // Удаляем символ '#', если он есть
  if (hex.length == 6) {
    hex =
        'FF$hex'; // Добавляем FF для полной непрозрачности, если строка из 6 символов
  }
  if (hex == '') {
    return Colors.black;
  } else {
    return Color(int.parse(hex, radix: 16));
  }
}

/// Преобразует объект `Color` в строку HEX (например, `#FF5733`).
String _colorToHex(Color color) {
  // Преобразуем `Color.value` в строку HEX и оставляем только `RRGGBB` часть
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}
