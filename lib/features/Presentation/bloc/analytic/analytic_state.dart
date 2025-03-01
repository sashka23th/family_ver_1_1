part of 'analytic_bloc.dart';

abstract class AnalyticState extends Equatable {
  const AnalyticState();

  @override
  List<Object> get props => [];
}

final class AnalyticEmptyState extends AnalyticState {}

final class AnalyticLoadingState extends AnalyticState {}

final class AnalyticErrorState extends AnalyticState {
  final String message;

  const AnalyticErrorState({required this.message});
}

final class AnalyticTotalLoadedState extends AnalyticState {
  final String total;

  const AnalyticTotalLoadedState({required this.total});
}

final class AnalyticLastLimitState extends AnalyticState {
  final List<PaymentEntity> analyticPayments;

  const AnalyticLastLimitState({required this.analyticPayments});
}

final class AnalyticFutureLoadedState extends AnalyticState {
  final List<AnalyticFutureEnity> analyticFuture;

  const AnalyticFutureLoadedState({required this.analyticFuture});
}

final class AnalyticMonthLoadedState extends AnalyticState {
  final AnalyticMonthEnity analyticMonth;

  const AnalyticMonthLoadedState({required this.analyticMonth});
}

final class AnalyticRecurringLoadedState extends AnalyticState {
  final List<PaymentEntity> analyticRecurring;

  const AnalyticRecurringLoadedState({required this.analyticRecurring});
}

final class AnalyticLastLoadedState extends AnalyticState {
  final List<PaymentEntity> analyticPayments;

  const AnalyticLastLoadedState({required this.analyticPayments});
}
