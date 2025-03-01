import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';

abstract class IFamilyRepository {
  Future<Either<Failure, List<FamilyEntity>>> getFamilies();
  Future<Either<Failure, FamilyEntity>> getFamilyDefault();
  Future<Either<Failure, String>> setFamilyDefault(int id);
  Future<Either<Failure, void>> addNewFamily(FamilyEntity family);
  Future<Either<Failure, void>> deleteFamily(int id);
}
