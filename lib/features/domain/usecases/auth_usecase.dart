import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/login_entity.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';
import 'package:family_cash/features/domain/repositories/auth_repository.dart';

class AuthUsecase {
  final IAuthRepository repository;

  AuthUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> loginUser(LoginEntity login) async {
    return await repository.loginUser(login);
  }

  Future<Either<Failure, UserEntity>> loginFromToken() async {
    return await repository.loginFromToken();
  }

  Future<Either<Failure, void>> logoutUser() async {
    return await repository.logoutUser();
  }

  Future<Either<Failure, UserEntity>> registerUser(LoginEntity user) async {
    return await repository.registerUser(user);
  }

  Future<Either<Failure, void>> forgotUserPassword(String email) async {
    return await repository.forgotUserPassword(email);
  }
}
