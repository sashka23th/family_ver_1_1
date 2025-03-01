import 'package:bloc/bloc.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';
import 'package:family_cash/features/domain/usecases/family_usecase.dart';
part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamilyUsecase familyUsecase;

  FamilyBloc({required this.familyUsecase}) : super(FamilyEmptyState()) {
    on<GetEmptyFamiliesEvent>((event, emit) {
      emit(FamilyEmptyState());
    });

    on<GetAllFamiliesEvent>((event, emit) async {
      emit(FamilyLoadingState());
      //await Future.delayed(const Duration(seconds: 1));
      final failOrFamilies = await familyUsecase.getFamilies();
      final failOrFamilyDefault = await familyUsecase.getFamilyDefault();
      final familyDefault = failOrFamilyDefault
          .getOrElse(() => const FamilyEntity(id: -1, name: "No family"));

      failOrFamilies.fold(
          (l) => emit(FamilyErrorState(message: l.message.toString())),
          (families) => emit(FamilyLoadedState(
              families: families,
              familyDefault: familyDefault,
              familyDefaultId: familyDefault.id)));
    });

    on<SetDefaultFamilyEvent>((event, emit) async {
      emit(FamilyLoadingState());

      final failOrNull = await familyUsecase.setFamilyDefault(event.id);
      failOrNull.fold(
        (l) => emit(FamilyUpdatedDefaultState(message: l.message)),
        (r) => emit(FamilyUpdatedDefaultState(message: "Sucsess updated")),
      );
    });

    on<AddNewFamilyEvent>((event, emit) async {
      emit(FamilyLoadingState());
      final failOrAdd = await familyUsecase.addNewFamily(event.newFamily);
      failOrAdd.fold(
        (l) => emit(FamilyUpdatedDefaultState(message: l.message)),
        (r) => emit(FamilyUpdatedDefaultState(message: "Family added sucsess")),
      );
    });

    on<DeleteFamilyEvent>((event, emit) async {
      emit(FamilyLoadingState());
      final failOrAdd = await familyUsecase.deleteFamily(event.id);
      failOrAdd.fold(
        (l) => emit(FamilyUpdatedDefaultState(message: l.message)),
        (r) =>
            emit(FamilyUpdatedDefaultState(message: "Family deleted sucsess")),
      );
    });
  }
}
