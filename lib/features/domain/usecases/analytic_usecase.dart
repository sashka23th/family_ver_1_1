import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';
import 'package:family_cash/features/domain/entity/analytic_month_enity.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/features/domain/repositories/analytic_repository.dart';

class AnalyticUsecase {
  final IAnalyticRepository analyticRepository;

  AnalyticUsecase({required this.analyticRepository});

  Future<Either<Failure, double>> getTotalSum(int famalyId) async {
    return await analyticRepository.getTotalSum(famalyId);
  }

  Future<Either<Failure, List<AnalyticFutureEnity>>> getFutureSum(
      int famalyId) async {
    return await analyticRepository.getFutureSum(famalyId);
  }

  Future<Either<Failure, List<PaymentEntity>>> getRecurringPayments(
      int famalyId) async {
    return await analyticRepository.getRecurringPayments(famalyId);
  }

  Future<Either<Failure, AnalyticMonthEnity>> getMonthPayments(
      int famalyId, int fromMonth) async {
    return await analyticRepository.getMonthPayments(famalyId, fromMonth);
  }

  Future<Either<Failure, List<PaymentEntity>>> getLastPayments(
      int famalyId, int limit) async {
    return await analyticRepository.getLastPayments(famalyId, limit);
  }
}
