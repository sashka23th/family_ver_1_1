import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';
import 'package:family_cash/features/domain/entity/analytic_month_enity.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

abstract class IAnalyticRepository {
  Future<Either<Failure, double>> getTotalSum(int familyId);
  Future<Either<Failure, List<AnalyticFutureEnity>>> getFutureSum(int familyId);
  Future<Either<Failure, List<PaymentEntity>>> getRecurringPayments(
      int familyId);
  Future<Either<Failure, List<PaymentEntity>>> getLastPayments(
      int familyId, int limit);
  Future<Either<Failure, AnalyticMonthEnity>> getMonthPayments(
      int familyId, int fromMonth);
}
