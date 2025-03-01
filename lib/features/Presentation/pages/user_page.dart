// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_cash/features/Presentation/bloc/family/family_bloc.dart';
// import 'package:family_cash/features/Presentation/bloc/user/user_bloc.dart';
// import 'package:family_cash/features/Presentation/widget/loading_state_widget.dart';
// import 'package:family_cash/locator_server.dart';

// class UserPage extends StatelessWidget {
//   const UserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userBloc = sl<UserBloc>()..add(GetUserEvent());

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => userBloc,
//         ),
//         BlocProvider(
//           create: (context) => sl<FamilyBloc>(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//             title: const Text(
//           'Главная страница',
//         )),
//         body: BlocBuilder<UserBloc, UserState>(
//           builder: (context, state) {
//             if (state is UserLoadingState) {
//               return loadingStateWidget();
//             } else if (state is UserLoadedState) {
//               return _loadedStateUser(state);
//             } else if (state is UserErrorState) {
//               return _errorStateUser(state);
//             } else {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   "Hi, Someone.",
//                   style: TextStyle(fontSize: 38),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// Widget _errorStateUser(UserErrorState state) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Text(" Error"),
//       Text(state.message),
//       ElevatedButton(
//           onPressed: () {}, child: const Text("Try to login or registred"))
//     ]),
//   );
// }

// Widget _loadedStateUser(UserLoadedState state) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           "Hi ${state.user.name}",
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 10),
//         Text("your email: ${state.user.email}"),
//       ],
//     ),
//   );
// }
