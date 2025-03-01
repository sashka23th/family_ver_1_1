import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Prefix { bnk, dev, exp }

Prefix parsePrefix(String prefix) {
  return Prefix.values.firstWhere(
    (e) => e.name == prefix,
    orElse: () => throw Exception('Invalid prefix: $prefix'),
  );
}

// Метод для конвертации enum в читабельную строку
String prefixToString(Prefix prefix) {
  switch (prefix) {
    case Prefix.bnk:
      return 'Банки';
    case Prefix.dev:
      return 'Доходы';
    case Prefix.exp:
      return 'Расходы';
  }
}

class CategoryEntity extends Equatable {
  final int id;
  final int familyId;
  final String name;
  final Prefix prefix;
  final String? details;
  final DateTime? createdAt;
  final IconData icon;
  final Color iconColor;

  const CategoryEntity(
      {required this.iconColor,
      this.createdAt,
      required this.id,
      required this.familyId,
      required this.name,
      required this.prefix,
      required this.details,
      required this.icon});

  @override
  List<Object> get props => [id];
}
