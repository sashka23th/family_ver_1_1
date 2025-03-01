part of '../../pages/home_page.dart';

Widget _buildLoginForm(
    BuildContext context, AuthState state, AuthBloc authBloc) {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusPassword = FocusNode();

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Верхняя половина с изображением профиля
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/login_image.png'), // Добавьте ваш путь к изображению
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      if (state is AuthErrorState) errorMessageWidget(state.message),

      // Нижняя половина с полями ввода и кнопками
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(focusPassword);
              },
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              focusNode: focusPassword,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    LoginEvent(emailController.text, passwordController.text),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _showRegistrationDialog(context, authBloc),
                  child: const Text('Register'),
                ),
                const Text('/'),
                TextButton(
                  onPressed: () => _showResetPasswordDialog(context, authBloc),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
