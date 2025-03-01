part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryEmpty extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoryLoaded({required this.categories});
}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});
}

final class CategoryAdded extends CategoryState {
  final String message;

  const CategoryAdded({required this.message});
}
