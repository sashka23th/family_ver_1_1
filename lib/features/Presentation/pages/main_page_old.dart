import 'package:flutter/material.dart';
import 'package:family_cash/features/Presentation/pages/register_user_page.dart';

class MainPageOld extends StatelessWidget {
  const MainPageOld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная страница')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterUserPage()));
              },
              child: const Text('Регистрация пользователя'),
            ),
            // Остальные кнопки для регистрации семьи, категории и создания записи
          ],
        ),
      ),
    );
  }
}
