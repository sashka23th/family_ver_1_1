import 'dart:convert';

import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'PAYMENT_SHARED';

abstract class PaymentLocalSource {
  Future<List<PaymentModel>> getPayments();
  Future<void> setPayments(List<PaymentModel> payments);
  Future<void> removePaymentsFromCache();
}

class PaymentLocalSourceImpl implements PaymentLocalSource {
  final SharedPreferences sharedPreferences;

  PaymentLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PaymentModel>> getPayments() async {
    final List<String>? payments = sharedPreferences.getStringList(key);
    if (payments != null && payments.isNotEmpty) {
      return payments
          .map((payment) => PaymentModel.fromJson(jsonDecode(payment)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPayments(List<PaymentModel> payments) async {
    final List<String> list =
        payments.map((payment) => jsonEncode(payment.toJson())).toList();
    await sharedPreferences.setStringList(key, list);
  }

  @override
  Future<void> removePaymentsFromCache() async {
    await sharedPreferences.remove(key);
  }
}
