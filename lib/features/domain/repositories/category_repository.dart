import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';

abstract class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryModel category);
  Future<Either<Failure, void>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> deleteCategory(int id);
}
