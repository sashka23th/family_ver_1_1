import 'dart:convert';

import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/analytic_future_model.dart';
import 'package:family_cash/features/data/models/analytic_month_model.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';

abstract class AnalyticRemoteSource {
  Future<double> getTotalSum(String token, int familyId, int activeDay);
  Future<List<AnalyticFutureEnity>> getFutureSum(
      String token, int familyId, int activeDay);
  Future<List<PaymentModel>> getRecurringPayments(
      String token, int familyId, int activeDay);
  Future<List<PaymentModel>> getLastPayments(
      String token, int familyId, int limit);
  Future<AnalyticMonthModel> getMonthPayments(
      String token, int familyId, int fromMonth, int activeDay);
}

class AnalyticRemoteSourceImpl implements AnalyticRemoteSource {
  @override
  Future<double> getTotalSum(String token, int familyId, int activeDay) async {
    final response = await RemoteRequest(token: token)
        .call("analytic/total/$familyId/$activeDay", 'GET');
    final Map<String, dynamic> data = json.decode(response.body);
    return returnDouble(data['sum']);
  }

  @override
  Future<List<AnalyticFutureEnity>> getFutureSum(
      String token, int familyId, int activeDay) async {
    final response = await RemoteRequest(token: token)
        .call("analytic/future/$familyId/$activeDay", 'GET');

    // Преобразуем JSON-ответ в список объектов AnalyticFutureEnity
    final List<dynamic> data = json.decode(response.body);
    final analyticFutureModel =
        data.map((json) => AnalyticFutureModel.fromJson(json)).toList();

    return analyticFutureModel;
  }

  @override
  Future<AnalyticMonthModel> getMonthPayments(
    String token,
    int familyId,
    int fromMonth,
    int activeDay,
  ) async {
    final response = await RemoteRequest(token: token)
        .call("analytic/month/$familyId/$activeDay/$fromMonth", 'GET');

    // Распарсим JSON
    final Map<String, dynamic> data = json.decode(response.body);

    // Создаем объект AnalyticMonthModel
    final analyticMonth = AnalyticMonthModel.fromJson(data);

    // Выводим данные
    return analyticMonth;
  }

  @override
  Future<List<PaymentModel>> getRecurringPayments(
      String token, int familyId, int activeDay) async {
    final response = await RemoteRequest(token: token)
        .call("analytic/recurring/$familyId/$activeDay", 'GET');

    // Преобразуем JSON-ответ в список объектов AnalyticFutureEnity
    final List<dynamic> data = json.decode(response.body);
    final analyticFRecurringModel =
        data.map((json) => PaymentModel.fromJson(json)).toList();

    return analyticFRecurringModel;
  }

  @override
  Future<List<PaymentModel>> getLastPayments(
      String token, int familyId, int limit) async {
    final response = await RemoteRequest(token: token)
        .call("analytic/last/$familyId/$limit", 'GET');

    // Преобразуем JSON-ответ в список объектов AnalyticFutureEnity
    final List<dynamic> data = json.decode(response.body);
    final analyticFRecurringModel =
        data.map((json) => PaymentModel.fromJson(json)).toList();

    return analyticFRecurringModel;
  }
}
