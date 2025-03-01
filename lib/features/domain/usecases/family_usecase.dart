import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';
import 'package:family_cash/features/domain/repositories/family_repository.dart';

class FamilyUsecase {
  final IFamilyRepository familyRepository;

  FamilyUsecase({required this.familyRepository});

  Future<Either<Failure, List<FamilyEntity>>> getFamilies() async {
    return await familyRepository.getFamilies();
  }

  Future<Either<Failure, FamilyEntity>> getFamilyDefault() async {
    return await familyRepository.getFamilyDefault();
  }

  Future<Either<Failure, String>> setFamilyDefault(int id) async {
    return await familyRepository.setFamilyDefault(id);
  }

  Future<Either<Failure, void>> addNewFamily(FamilyEntity family) async {
    return await familyRepository.addNewFamily(family);
  }

  Future<Either<Failure, void>> deleteFamily(int id) async {
    return await familyRepository.deleteFamily(id);
  }
}
