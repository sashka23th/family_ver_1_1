
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   String _password = '';
//   String _deviceName = '';
//   final tokenBloc = sl<TokenBloc>();

//   @override
//   void initState() {
//     super.initState();
//     _getDeviceName();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<TokenBloc>(
//       create: (context) => tokenBloc,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Авторизация')),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: BlocBuilder<TokenBloc, TokenState>(
//             bloc: tokenBloc,
//             builder: (context, state) {
//               if (state is TokenLoadingState) {
//                 return loadingStateWidget();
//               } else if (state is TokenLoadedState) {
//                 return _loadedState(state);
//               } else if (state is TokenErrorState) {
//                 return _errorState(state.message);
//               } else {
//                 return _emptyState();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _getDeviceName() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     try {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       _deviceName = androidInfo.model;
//     } catch (e) {
//       WebBrowserInfo webInfo = (await deviceInfo.webBrowserInfo);
//       _deviceName = webInfo.browserName.name;
//     }

//     setState(() {});
//   }

//   Widget _errorState(TokenMessageEntity message) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _emptyState(),
//           Text(
//             message.email,
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//           ),
//           Text(
//             message.password,
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//           ),
//           Text(
//             message.deviceName,
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _emptyState() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Email'),
//             validator: (value) {
//               if (value!.isEmpty) return 'Введите email';
//               return null;
//             },
//             onSaved: (value) => _email = value!,
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Пароль'),
//             obscureText: true,
//             validator: (value) {
//               if (value!.isEmpty) return 'Введите пароль';
//               return null;
//             },
//             onSaved: (value) => _password = value!,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             "Device name: $_deviceName",
//             style: const TextStyle(fontSize: 16.0),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 _login();
//               }
//             },
//             child: const Text('Войти'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _loadedState(TokenLoadedState state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Configuration, you get token:",
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 10),
//         Text(state.token.token),
//         const SizedBox(height: 20),
//         ElevatedButton(
//             onPressed: () {
//               tokenBloc.add(CleanTokenEvent());
//             },
//             child: const Text("Clean token"))
//       ],
//     );
//   }

//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       final LoginEntity login = LoginEntity(
//           email: _email, password: _password, deviceName: _deviceName);
//       tokenBloc.add(GetTokenEvent(login: login));
//     }
//   }
// }
