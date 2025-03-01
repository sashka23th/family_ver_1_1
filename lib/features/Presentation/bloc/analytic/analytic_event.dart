part of 'analytic_bloc.dart';

abstract class AnalyticEvent extends Equatable {
  const AnalyticEvent();

  @override
  List<Object> get props => [];
}

class GetTotalEvent extends AnalyticEvent {
  final int familyId;

  const GetTotalEvent({required this.familyId});
}

class GetFurureEvent extends AnalyticEvent {
  final int familyId;

  const GetFurureEvent({required this.familyId});
}

class GetRecurringEvent extends AnalyticEvent {
  final int familyId;

  const GetRecurringEvent({required this.familyId});
}

class GetMonthEvent extends AnalyticEvent {
  final int familyId;
  final int fromMonth;

  const GetMonthEvent({required this.familyId, required this.fromMonth});
}

class GetLastLimitEvent extends AnalyticEvent {
  final int familyId;

  const GetLastLimitEvent({required this.familyId});
}
