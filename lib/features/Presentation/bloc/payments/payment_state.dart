part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentsEmptyState extends PaymentState {}

class PaymentsLoadingState extends PaymentState {}

class PaymentsMassageState extends PaymentState {
  final String message;

  const PaymentsMassageState({required this.message});
}

class PaymentDeletedState extends PaymentState {}

class PaymentsLoadedState extends PaymentState {
  final List<PaymentsOpenEntity> payments;

  const PaymentsLoadedState({required this.payments});
}
