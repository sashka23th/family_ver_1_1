import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:family_cash/core/error/exceptions.dart';
import 'package:family_cash/core/error/failures.dart';
import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/data/datasources/local/payment_local_source.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/payment_remote_source.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final TokenLocalSource tokenLocalSource;
  final NetworkInfo networkInfo;
  final PaymentLocalSource paymentLocalSource;
  final PaymentRemoteSource paymentRemoteSource;

  PaymentRepositoryImpl(
      {required this.tokenLocalSource,
      required this.networkInfo,
      required this.paymentLocalSource,
      required this.paymentRemoteSource});

  @override
  Future<Either<Failure, void>> addPayment(PaymentModel payment) async {
    try {
      _localWithModel(payment);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(int id) async {
    try {
      _localWithModel(PaymentModel(
          categoryId: -1,
          amount: 0,
          date: DateTime.now(),
          id: id,
          amountFull: 0,
          isRecurring: false,
          numberOfPayments: 0,
          action: 'delete',
          createAt: DateTime.now()));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePayment(PaymentModel payment) async {
    try {
      _localWithModel(payment);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refresfPayments() async {
    try {
      _remotePayments([]);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  void _localWithModel(PaymentModel payment) async {
    final paymentsLocal = await paymentLocalSource.getPayments();
    paymentsLocal.add(payment);
    await paymentLocalSource.setPayments(paymentsLocal);
    _remotePayments(paymentsLocal);
  }

  void _remotePayments(List<PaymentModel> payments) async {
    if (payments.isEmpty) {
      payments = await paymentLocalSource.getPayments();
    }

    if (payments.isNotEmpty) {
      final token = await tokenLocalSource.getTokenFromCache();
      // Создаем копию списка, чтобы избежать изменения списка во время итерации
      final List<PaymentModel> paymentsCopy = List.from(payments);

      for (var payment in paymentsCopy) {
        if (payment.action == 'delete') {
          try {
            await paymentRemoteSource.deletePaymentFromRemote(
                token, payment.id);
          } on ServerException {
            throw NextFocusAction();
          }

          // Если отправка успешна, удаляем элемент из оригинального списка
          payments.remove(payment);
        }

        if (payment.action == 'update') {
          await paymentRemoteSource.updatePaymentToRemote(token, payment);
          // Если отправка успешна, удаляем элемент из оригинального списка
          payments.remove(payment);
        }

        if (payment.action == 'insert') {
          await paymentRemoteSource.setPaymentToRemote(token, payment);
          // Если отправка успешна, удаляем элемент из оригинального списка
          payments.remove(payment);
        }
      }
    }
    if (payments.isEmpty) {
      await paymentLocalSource.removePaymentsFromCache();
    }
  }

  @override
  Future<Either<Failure, List<PaymentModel>>> openPayments() async {
    final openPayments = await paymentLocalSource.getPayments();
    return Right(openPayments);
  }
}
