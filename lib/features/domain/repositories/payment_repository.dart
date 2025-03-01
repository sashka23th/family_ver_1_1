import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

abstract class IPaymentRepository {
  Future<Either<Failure, void>> addPayment(PaymentModel payment);
  Future<Either<Failure, void>> updatePayment(PaymentModel payment);
  Future<Either<Failure, void>> deletePayment(int id);
  Future<Either<Failure, void>> refresfPayments();
  Future<Either<Failure, List<PaymentsOpenEntity>>> openPayments();
}
