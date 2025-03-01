import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// События
abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final Color devColor;
  final Color expiColor;
  final Color bankColor;
  final int activeDay;

  UpdateSettings(this.devColor, this.expiColor, this.bankColor, this.activeDay);
}

// Состояние
class SettingsState {
  final Color devColor;
  final Color expiColor;
  final Color bankColor;
  final int activeDay;

  SettingsState({
    required this.devColor,
    required this.expiColor,
    required this.bankColor,
    required this.activeDay,
  });
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(
          devColor: Colors.red,
          expiColor: Colors.green,
          bankColor: Colors.blue,
          activeDay: 1,
        )) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      devColor: Color(prefs.getInt('devColor') ?? Colors.red.value),
      expiColor: Color(prefs.getInt('expiColor') ?? Colors.green.value),
      bankColor: Color(prefs.getInt('bankColor') ?? Colors.blue.value),
      activeDay: prefs.getInt('activeDay') ?? 10,
    ));
  }

  Future<void> _onUpdateSettings(
      UpdateSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('devColor', event.devColor.value);
    await prefs.setInt('expiColor', event.expiColor.value);
    await prefs.setInt('bankColor', event.bankColor.value);
    await prefs.setInt('activeDay', event.activeDay);
    emit(SettingsState(
      devColor: event.devColor,
      expiColor: event.expiColor,
      bankColor: event.bankColor,
      activeDay: event.activeDay,
    ));
  }
}
