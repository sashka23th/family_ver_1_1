import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:family_cash/features/Presentation/bloc/settings_bloc.dart';
import 'package:family_cash/locator_server.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color _devColor = Colors.red;
  Color _expiColor = Colors.green;
  Color _bankColor = Colors.blue;
  int _activeDay = 1;
  final settingsBloc = sl<SettingsBloc>();

  @override
  void initState() {
    super.initState();
    final state = settingsBloc.state;
    _devColor = state.devColor;
    _expiColor = state.expiColor;
    _bankColor = state.bankColor;
    _activeDay = state.activeDay;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => settingsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Параметры'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildColorPicker('Цвет Дэв', _devColor, (color) {
                setState(() => _devColor = color);
              }),
              buildColorPicker('Цвет Эйкспи', _expiColor, (color) {
                setState(() => _expiColor = color);
              }),
              buildColorPicker('Цвет Бэнк', _bankColor, (color) {
                setState(() => _bankColor = color);
              }),
              const SizedBox(height: 20),
              DropdownButton<int>(
                value: _activeDay,
                items: List.generate(
                  31,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('День ${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _activeDay = value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  settingsBloc.add(UpdateSettings(
                    _devColor,
                    _expiColor,
                    _bankColor,
                    _activeDay,
                  ));
                  Navigator.pop(context);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorPicker(
      String title, Color currentColor, ValueChanged<Color> onColorChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        GestureDetector(
          onTap: () async {
            final color = await showDialog<Color>(
              context: context,
              builder: (context) => AlertDialog(
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: currentColor,
                    onColorChanged: onColorChanged,
                  ),
                ),
              ),
            );
            if (color != null) onColorChanged(color);
          },
          child: CircleAvatar(backgroundColor: currentColor),
        ),
      ],
    );
  }
}
