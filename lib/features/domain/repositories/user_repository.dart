import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> getUser();
  Future<Either<Failure, UserEntity>> addUser();
  // Future<Either<Failure, void>> updateUser(UserEntity user);
  // Future<Either<Failure, void>> deleteUser(String token);
}
