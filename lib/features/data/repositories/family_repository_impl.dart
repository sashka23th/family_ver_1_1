import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/exceptions.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/data/datasources/local/family_local_source.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/family_remote_source.dart';
import 'package:family_cash/features/data/models/response_model.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';
import 'package:family_cash/features/domain/repositories/family_repository.dart';

class FamilyRepositoryImpl implements IFamilyRepository {
  final TokenLocalSource tokenLocalSource;
  final NetworkInfo networkInfo;
  final FamilyLocalSource familyLocalSource;
  final FamailyRemoteSource famailyRemoteSource;

  FamilyRepositoryImpl(
      {required this.tokenLocalSource,
      required this.networkInfo,
      required this.familyLocalSource,
      required this.famailyRemoteSource});

  @override
  Future<Either<Failure, List<FamilyEntity>>> getFamilies() async {
    try {
      final families = await familyLocalSource.getFamiliesFromCache();
      if (families.isNotEmpty) {
        return Right(families);
      } else {
        final token = await tokenLocalSource.getTokenFromCache();
        final families = await famailyRemoteSource.getFamiliesFromRemote(token);
        await familyLocalSource.setFamiliesToCache(families);
        return Right(families);
      }
    } on ServerFailure {
      return const Left(ServerFailure(message: ""));
    } on CacheFailure {
      return const Left(CacheFailure(message: "Problem with get families"));
    } catch (e) {
      return const Left(CacheFailure(message: "No family founded"));
    }
  }

  @override
  Future<Either<Failure, FamilyEntity>> getFamilyDefault() async {
    try {
      final result = await familyLocalSource.getFamilyDefault();
      return Right(result);
    } on CacheException {
      return Left(CacheException() as Failure);
    } catch (e) {
      return const Left(CacheFailure(message: "No family default founded"));
    }
  }

  @override
  Future<Either<Failure, String>> setFamilyDefault(int id) async {
    try {
      final result = await familyLocalSource.setFamilyDefault(id);
      return Right(result);
    } on CacheException {
      return Left(CacheException() as Failure);
    } catch (e) {
      return const Left(CacheFailure(message: "Trouble with set default"));
    }
  }

  @override
  Future<Either<Failure, void>> addNewFamily(FamilyEntity family) async {
    try {
      final token = await tokenLocalSource.getTokenFromCache();
      final ResponseModel responseModel =
          await famailyRemoteSource.setFamilyToRemoute(token, family);
      //await familyLocalSource.removeFamiliesFromCache();
      final families = await famailyRemoteSource.getFamiliesFromRemote(token);
      await familyLocalSource.setFamiliesToCache(families);
      if (responseModel.success) {
        await familyLocalSource.setFamilyDefault(responseModel.family!.id);
      }

      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure(message: ""));
    }
  }

  // @override
  // Future<Either<Failure, void>> updateFamilyInRemote(
  //     FamilyEntity family) async {
  //   try {
  //     final token = await tokenLocalSource.getTokenFromCache();
  //     final result = await famailyRemoteSource.updateFamilyInRemoute(
  //         token, family as FamilyModel);
  //     return Right(result);
  //   } on CacheFailure {
  //     return Left(CacheFailure(message: ""));
  //   }
  // }

  @override
  Future<Either<Failure, void>> deleteFamily(int id) async {
    try {
      final token = await tokenLocalSource.getTokenFromCache();
      final result = await famailyRemoteSource.deleteFamilyInRemoute(token, id);
      final families = await famailyRemoteSource.getFamiliesFromRemote(token);
      await familyLocalSource.setFamiliesToCache(families);

      // ignore: void_checks
      return Right(result);
    } on CacheFailure {
      return const Left(CacheFailure(message: ""));
    }
  }
}
