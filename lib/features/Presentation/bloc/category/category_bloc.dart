import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';
import 'package:family_cash/features/domain/usecases/category_usercase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryUsercase categoryUsercase;

  CategoryBloc({required this.categoryUsercase}) : super(CategoryEmpty()) {
    on<GetCategoriesEvent>(_onGetingCategories);

    on<AddCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      await categoryUsercase.addCategory(event.categoryModel);
      final failOrCategories = await categoryUsercase.getCategories();
      emit(CategoryLoaded(categories: failOrCategories.getOrElse(() => [])));
    });

    on<UpdateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      await categoryUsercase.updateCategory(event.categoryModel);
      final failOrCategories = await categoryUsercase.getCategories();
      emit(CategoryLoaded(categories: failOrCategories.getOrElse(() => [])));
    });

    on<DeleteCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      final failOrDelete = await categoryUsercase.deleteCategory(event.id);
      final failOrCategories = await categoryUsercase.getCategories();
      failOrDelete.fold((l) async {
        emit(CategoryError(message: l.message));
        emit(CategoryLoaded(categories: failOrCategories.getOrElse(() => [])));
      },
          (r) => emit(CategoryLoaded(
              categories: failOrCategories.getOrElse(() => []))));
    });
  }

  Future<void> _onGetingCategories(event, emit) async {
    emit(CategoryLoading());
    final failOrCategories = await categoryUsercase.getCategories();
    emit(CategoryLoaded(categories: failOrCategories.getOrElse(() => [])));
  }
}
