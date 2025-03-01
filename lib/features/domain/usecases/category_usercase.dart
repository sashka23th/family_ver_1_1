import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';
import 'package:family_cash/features/domain/repositories/category_repository.dart';

class CategoryUsercase {
  final ICategoryRepository categoryRepository;

  CategoryUsercase({required this.categoryRepository});

  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return await categoryRepository.getCategories();
  }

  Future<Either<Failure, void>> updateCategory(CategoryModel params) async {
    return await categoryRepository.updateCategory(params);
  }

  Future<Either<Failure, void>> addCategory(CategoryModel params) async {
    return await categoryRepository.addCategory(params);
  }

  Future<Either<Failure, void>> deleteCategory(int id) async {
    return await categoryRepository.deleteCategory(id);
  }
}
