import 'dart:convert';

import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/data/models/response_model.dart';

abstract class PaymentRemoteSource {
  Future<ResponseModel> setPaymentToRemote(String token, PaymentModel payment);
  Future<ResponseModel> updatePaymentToRemote(
      String token, PaymentModel payment);
  Future<ResponseModel> deletePaymentFromRemote(String token, int id);
}

class PaymentRemoteSourceImpl implements PaymentRemoteSource {
  @override
  Future<ResponseModel> setPaymentToRemote(
      String token, PaymentModel payment) async {
    final response = await RemoteRequest(token: token)
        .call("payment/add", 'POST', body: payment);
    return ResponseModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ResponseModel> deletePaymentFromRemote(String token, int id) async {
    final response =
        await RemoteRequest(token: token).call("payment/delete/$id", 'DELETE');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      return ResponseModel(
          success: false,
          message: response.reasonPhrase ?? 'no payment to delete');
    }
  }

  @override
  Future<ResponseModel> updatePaymentToRemote(
      String token, PaymentModel payment) async {
    final response = await RemoteRequest(token: token)
        .call("payment/update", 'POST', body: payment);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      return ResponseModel(
          success: false,
          message: response.reasonPhrase ?? 'no payment to update');
    }
  }
}
