part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class AddPaymentsEvent extends PaymentEvent {
  final PaymentModel paymentModel;

  const AddPaymentsEvent({required this.paymentModel});
}

class UpdatePaymentsEvent extends PaymentEvent {
  final PaymentModel paymentModel;

  const UpdatePaymentsEvent({required this.paymentModel});
}

class DeletePaymentsEvent extends PaymentEvent {
  final int id;

  const DeletePaymentsEvent({required this.id});
}

class OpenPaymentsEvent extends PaymentEvent {}

class RefreshPaymentsEvent extends PaymentEvent {}
