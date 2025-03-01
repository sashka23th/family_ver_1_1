import 'package:flutter/material.dart';
import 'package:family_cash/features/Presentation/pages/home_page.dart';
import 'package:family_cash/locator_server.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Семейный бюджет',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 99, 190)),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
