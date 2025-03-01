import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/features/domain/repositories/payment_repository.dart';

class PaymentUsecase {
  final IPaymentRepository paymentRepository;

  PaymentUsecase({required this.paymentRepository});

  Future<Either<Failure, void>> updatePayment(PaymentModel params) async {
    return await paymentRepository.updatePayment(params);
  }

  Future<Either<Failure, void>> addPayment(PaymentModel params) async {
    return await paymentRepository.addPayment(params);
  }

  Future<Either<Failure, void>> deletePayment(int id) async {
    return await paymentRepository.deletePayment(id);
  }

  Future<Either<Failure, void>> refresfPayments() async {
    return await paymentRepository.refresfPayments();
  }

  Future<Either<Failure, List<PaymentsOpenEntity>>> openPayments() async {
    return await paymentRepository.openPayments();
  }
}
