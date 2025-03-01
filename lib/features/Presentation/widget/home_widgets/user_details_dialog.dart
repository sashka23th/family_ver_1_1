part of '../../pages/home_page.dart';

void _showUserDetails(BuildContext context, UserEntity user, AuthBloc authBloc,
    FamilyBloc familyBloc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
            Text('Registration Date: ${user.registrationDate.toLocal()}'),
          ],
        ),
        actions: [
          // Кнопка Logout
          TextButton(
            onPressed: () {
              // Отправляем событие LogoutEvent для выхода из аккаунта
              familyBloc.add(GetEmptyFamiliesEvent());
              authBloc.add(LogoutEvent());
              Navigator.of(context).pop(); // Закрываем диалог
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                  color: Colors.red), // Красный цвет для кнопки Logout
            ),
          ),

          TextButton(
            onPressed: () {
              // Добавьте логику редактирования
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
