part of 'family_bloc.dart';

class FamilyState {}

class FamilyEmptyState extends FamilyState {}

class FamilyLoadingState extends FamilyState {}

class FamilyLoadedState extends FamilyState {
  final List<FamilyEntity> families;
  final FamilyEntity familyDefault;
  final int familyDefaultId;

  FamilyLoadedState(
      {required this.families,
      required this.familyDefault,
      required this.familyDefaultId});
}

class FamilyErrorState extends FamilyState {
  final String message;

  FamilyErrorState({required this.message});
}

class FamilyRefreshState extends FamilyState {
  final String message;

  FamilyRefreshState({required this.message});
}

class FamilyUpdatedDefaultState extends FamilyState {
  final String message;

  FamilyUpdatedDefaultState({required this.message});
}
