part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final CategoryModel categoryModel;

  const AddCategoryEvent({required this.categoryModel});
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModel categoryModel;

  const UpdateCategoryEvent({required this.categoryModel});
}

class DeleteCategoriesEvent extends CategoryEvent {
  final int id;

  const DeleteCategoriesEvent({required this.id});
}
