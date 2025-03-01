part of 'family_bloc.dart';

abstract class FamilyEvent {}

class GetAllFamiliesEvent extends FamilyEvent {}

class GetEmptyFamiliesEvent extends FamilyEvent {}

class GetFamilyDefaultEvent extends FamilyEvent {}

class RefreshFamiliesFromRemoteEvent extends FamilyEvent {}

class SetDefaultFamilyEvent extends FamilyEvent {
  final int id;

  SetDefaultFamilyEvent({required this.id});
}

class AddNewFamilyEvent extends FamilyEvent {
  final FamilyEntity newFamily;

  AddNewFamilyEvent({required this.newFamily});
}

class DeleteFamilyEvent extends FamilyEvent {
  final int id;

  DeleteFamilyEvent({required this.id});
}
