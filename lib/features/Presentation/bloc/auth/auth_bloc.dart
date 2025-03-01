import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_cash/features/domain/entity/login_entity.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';
import 'package:family_cash/features/domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase authUsecase;

  AuthBloc({required this.authUsecase}) : super(AuthInitialState()) {
    on<LoginFromTokenEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failOrUser = await authUsecase.loginFromToken();
      failOrUser.fold(
          (l) => emit(AuthErrorState(message: l.message.toString())),
          (r) => emit(AuthenticatedState(r)));
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      final failOrToken = await authUsecase.loginUser(LoginEntity(
          deviceName: "deviceName",
          password: event.password,
          email: event.email));
      failOrToken.fold(
          (l) => emit(AuthErrorState(message: l.message.toString())),
          (r) => emit(AuthenticatedState(r)));
    });

    // Обрабатываем событие LogoutEvent
    on<LogoutEvent>((event, emit) async {
      final response = await authUsecase.logoutUser();
      if (response.isLeft()) {
        return emit(AuthErrorState(message: "Error logout"));
      } else {
        emit(UnauthenticatedState());
      }
    });

    // Обрабатываем событие RegisterEvent
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        // Пример процесса регистрации
        final user = UserEntity(
          id: -1,
          name: event.name,
          email: event.email,
          registrationDate: DateTime.now(),
        );
        emit(AuthenticatedState(user));
      } catch (e) {
        emit(AuthErrorState(message: "Failed to register"));
      }
    });

    // Обрабатываем событие ForgotPasswordEvent
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await authUsecase.forgotUserPassword(event.email);
        emit(AuthInitialState()); // После восстановления сбрасываем состояние
      } catch (e) {
        emit(AuthErrorState(message: "Failed to reset password"));
      }
    });
  }
}
