import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/exceptions.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/data/datasources/local/category_local_source.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/category_remote_source.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';
import 'package:family_cash/features/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final TokenLocalSource tokenLocalSource;
  final NetworkInfo networkInfo;
  final CategoryLocalSource categoryLocalSource;
  final CategoryRemoteSource categoryRemoteSource;

  CategoryRepositoryImpl(
      {required this.tokenLocalSource,
      required this.networkInfo,
      required this.categoryLocalSource,
      required this.categoryRemoteSource});

  @override
  Future<Either<Failure, void>> addCategory(CategoryModel category) async {
    try {
      final token = await tokenLocalSource.getTokenFromCache();

      await categoryRemoteSource.setCategoryToRemote(token, category);
      final categories =
          await categoryRemoteSource.getCategoriesFromRemote(token);
      await categoryLocalSource.setCatigoriesList(categories);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      final token = await tokenLocalSource.getTokenFromCache();

      await categoryRemoteSource.delCategoryFromRemote(token, id);
      final categories =
          await categoryRemoteSource.getCategoriesFromRemote(token);
      await categoryLocalSource.setCatigoriesList(categories);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure(message: ""));
    } catch (e) {
      return const Left(ServerFailure(message: "Some wrong"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await categoryLocalSource.getCategories();
      if (categories.isNotEmpty) {
        return Right(categories);
      } else {
        final token = await tokenLocalSource.getTokenFromCache();
        final List<CategoryModel> categoriesFromRemote =
            await categoryRemoteSource.getCategoriesFromRemote(token);
        if (categoriesFromRemote.isNotEmpty) {
          return Right(categoriesFromRemote);
        } else {
          return const Left(ServerFailure(message: "No categories"));
        }
      }
    } on CacheException {
      return const Left(CacheFailure(message: "Problem with get categories"));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryModel category) async {
    try {
      final token = await tokenLocalSource.getTokenFromCache();

      await categoryRemoteSource.updateCategoryToRemote(token, category);
      final categories =
          await categoryRemoteSource.getCategoriesFromRemote(token);
      await categoryLocalSource.setCatigoriesList(categories);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure(message: ""));
    }
  }
}
