import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/analytic_month_enity.dart';

class AnalyticMonthModel extends AnalyticMonthEnity {
  AnalyticMonthModel({required super.period, required super.payments});

  // Фабричный метод для создания объекта из JSON
  factory AnalyticMonthModel.fromJson(Map<String, dynamic> json) {
    return AnalyticMonthModel(
      period: DateTime.parse(json['periud'] as String),
      payments: (json['payments'] as List<dynamic>)
          .map((paymentJson) => PaymentModel.fromJson(paymentJson))
          .toList(),
    );
  }
}
