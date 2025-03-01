import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/login_entity.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> loginUser(LoginEntity login);
  Future<Either<Failure, UserEntity>> loginFromToken();
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, UserEntity>> registerUser(LoginEntity user);
  Future<Either<Failure, void>> forgotUserPassword(String email);
}
