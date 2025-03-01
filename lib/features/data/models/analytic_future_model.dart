import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';

class AnalyticFutureModel extends AnalyticFutureEnity {
  AnalyticFutureModel({required super.periud, required super.sum});

  factory AnalyticFutureModel.fromJson(Map<String, dynamic> json) {
    return AnalyticFutureModel(
      periud: DateTime.parse(json['end_date']),
      sum: returnDouble(json['total_sum']),
    );
  }
}

double returnDouble(dynamic sum) {
  if (sum is int) {
    return sum.toDouble();
  } else if (sum is double) {
    return sum;
  } else if (sum is String) {
    return double.tryParse(sum) ?? 0.00;
  } else {
    return 0.00; // Handle cases where conversion is not possible
  }
}
