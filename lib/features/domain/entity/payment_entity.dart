import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int id;
  final int categoryId;
  final double amount;
  final double amountFull;
  final DateTime date;
  final bool isRecurring;
  final int numberOfPayments;
  final String? description;
  final int? installment;
  final DateTime createAt; // Номер платежа

  const PaymentEntity({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.amountFull,
    required this.date,
    required this.isRecurring,
    required this.numberOfPayments,
    this.description,
    this.installment,
    required this.createAt,
  });

  @override
  List<Object> get props => [id];
}

class PaymentsOpenEntity extends PaymentEntity {
  final String action;

  PaymentsOpenEntity(
      {required super.id,
      required super.categoryId,
      required super.amount,
      required super.amountFull,
      required super.date,
      required super.isRecurring,
      required super.numberOfPayments,
      required super.createAt,
      super.description,
      super.installment,
      required this.action});
}
