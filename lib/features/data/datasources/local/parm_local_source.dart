import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ParmLocalSource {
  Future<int> activeDay();
  Future<Color> devColor();
  Future<Color> expiColor();
  Future<Color> bankColor();
}

class ParmLocalSourceImpl implements ParmLocalSource {
  final SharedPreferences sharedPreferences;

  ParmLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<int> activeDay() async {
    return sharedPreferences.getInt('activeDay') ?? 10;
  }

  @override
  Future<Color> devColor() async {
    return Color(sharedPreferences.getInt('devColor') ?? Colors.red.value);
  }

  @override
  Future<Color> expiColor() async {
    return Color(sharedPreferences.getInt('expiColor') ?? Colors.green.value);
  }

  @override
  Future<Color> bankColor() async {
    return Color(sharedPreferences.getInt('bankColor') ?? Colors.blue.value);
  }
}
