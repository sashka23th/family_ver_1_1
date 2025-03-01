import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/exceptions.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/local/user_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/token_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/user_remote_source.dart';
import 'package:family_cash/features/data/models/login_model.dart';
import 'package:family_cash/features/data/models/token_model.dart';
import 'package:family_cash/features/domain/entity/login_entity.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';
import 'package:family_cash/features/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final TokenRemoteSource tokenRemote;
  final TokenLocalSource tokenLocalSource;
  final NetworkInfo networkInfo;
  final UserRemoteSource userRemoteSource;
  final UserLocalSource userLocalSource;

  AuthRepositoryImpl(
      {required this.tokenRemote,
      required this.tokenLocalSource,
      required this.networkInfo,
      required this.userRemoteSource,
      required this.userLocalSource});

  @override
  Future<Either<Failure, void>> forgotUserPassword(String email) async {
    try {
      final response = await userRemoteSource.forgotPassword();
      if (response.success) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: response.message.toString()));
      }
    } on ServerFailure {
      return const Left(ServerFailure(message: "Crash when tring to connect"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginFromToken() async {
    try {
      final String token = await tokenLocalSource.getTokenFromCache();
      if (token.isNotEmpty) {
        final userLocal = await userLocalSource.getUserFromCache();
        if (userLocal.id != -1) {
          return Right(userLocal);
        } else {
          final userRemote = await userRemoteSource.getUserRemote(token);
          if (userRemote.id != -1) {
            await userLocalSource.setUserToCache(userRemote);
            return Right(userRemote);
          } else {
            return const Left(
                ServerFailure(message: "No user founded, please login"));
          }
        }
      } else {
        return const Left(CacheFailure(message: "No token founded"));
      }
    } on CacheFailure {
      return const Left(CacheFailure(message: "Crash when try geting token"));
    } on ServerFailure {
      return const Left(ServerFailure(message: "Crash when tring to connect"));
    } catch (e) {
      return const Left(CacheFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginUser(LoginEntity login) async {
    try {
      final TokenModel token = await tokenRemote.getTokenRemote(login);
      if (token.success) {
        await tokenLocalSource.setTokenToCache(token.token);
        final user = await userRemoteSource.getUserRemote(token.token);
        await userLocalSource.setUserToCache(user);
        return Right(user);
      } else {
        return Left(ServerFailure(message: token.message.toString()));
      }
    } on ServerFailure {
      return const Left(ServerFailure(message: "Crash when tring to connect"));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await tokenLocalSource.delTokenFromCache();
      return const Right(null);
    } on CacheFailure {
      return const Left(CacheFailure(message: "Чтото пошло не так"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerUser(LoginEntity user) async {
    try {
      final response = await userRemoteSource.addUserRemote(user as LoginModel);
      await userLocalSource.setUserToCache(response);
      return Right(response);
    } on ServerException {
      return Left(ServerException(message: "Чтото пошло не так") as Failure);
    }
  }
}
