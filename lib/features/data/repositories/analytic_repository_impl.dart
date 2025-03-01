import 'package:dartz/dartz.dart';
import 'package:family_cash/core/error/exceptions.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/data/datasources/local/parm_local_source.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/analytic_remote_source.dart';
import 'package:family_cash/features/data/models/analytic_month_model.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/features/domain/repositories/analytic_repository.dart';

class AnalyticRepositoryImpl implements IAnalyticRepository {
  final TokenLocalSource tokenLocalSource;
  final NetworkInfo networkInfo;
  final AnalyticRemoteSource analyticRemoteSource;
  final ParmLocalSource parmLocalSource;

  AnalyticRepositoryImpl(
      {required this.tokenLocalSource,
      required this.networkInfo,
      required this.analyticRemoteSource,
      required this.parmLocalSource});

  @override
  Future<Either<Failure, double>> getTotalSum(int familyId) async {
    final startParsing = DateTime.now();
    try {
      if (await networkInfo.isConnected) {
        final String token = await tokenLocalSource.getTokenFromCache();

        final activeDay = await parmLocalSource.activeDay();

        final double total =
            await analyticRemoteSource.getTotalSum(token, familyId, activeDay);

        return Right(total);
      } else {
        return const Left(ServerFailure(message: "No internet connection"));
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'No connection'));
    } catch (e) {
      return const Left(ServerFailure(message: "Связь с интернетом потеряна"));
    }
    final endParsing = DateTime.now();
    print(
        'Get internet connection time: ${endParsing.difference(startParsing).inMilliseconds} ms');
  }

  @override
  Future<Either<Failure, List<AnalyticFutureEnity>>> getFutureSum(
      int familyId) async {
    if (await networkInfo.isConnected) {
      final String token = await tokenLocalSource.getTokenFromCache();
      final activeDay = await parmLocalSource.activeDay();
      final List<AnalyticFutureEnity> analyticFutureEnity =
          await analyticRemoteSource.getFutureSum(token, familyId, activeDay);
      return Right(analyticFutureEnity);
    } else {
      return const Left(ServerFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, AnalyticMonthModel>> getMonthPayments(
      int familyId, int fromMonth) async {
    try {
      if (await networkInfo.isConnected) {
        final String token = await tokenLocalSource.getTokenFromCache();
        final activeDay = await parmLocalSource.activeDay();
        final AnalyticMonthModel analyticMonthSource =
            await analyticRemoteSource.getMonthPayments(
                token, familyId, fromMonth, activeDay);
        return Right(analyticMonthSource);
      } else {
        return const Left(ServerFailure(message: "No internet connection"));
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'No connection'));
    } catch (e) {
      return const Left(ServerFailure(message: "Some wrong"));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getRecurringPayments(
      int familyId) async {
    try {
      if (await networkInfo.isConnected) {
        final String token = await tokenLocalSource.getTokenFromCache();
        final activeDay = await parmLocalSource.activeDay();
        final List<PaymentModel> analyticFutureEnity =
            await analyticRemoteSource.getRecurringPayments(
                token, familyId, activeDay);
        return Right(analyticFutureEnity);
      } else {
        return const Left(ServerFailure(message: "No internet connection"));
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'No connection'));
    } catch (e) {
      return const Left(ServerFailure(message: "Some wrong"));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getLastPayments(
      int familyId, int limit) async {
    try {
      if (await networkInfo.isConnected) {
        final String token = await tokenLocalSource.getTokenFromCache();
        final List<PaymentModel> analyticFutureEnity =
            await analyticRemoteSource.getLastPayments(token, familyId, limit);
        return Right(analyticFutureEnity);
      } else {
        return const Left(ServerFailure(message: "No internet connection"));
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'No connection'));
    } catch (e) {
      return const Left(ServerFailure(message: "Some wrong"));
    }
  }
}
