import 'package:family_cash/features/domain/entity/payment_entity.dart';

class AnalyticMonthEnity {
  final DateTime period;
  final List<PaymentEntity> payments;

  AnalyticMonthEnity({required this.period, required this.payments});
}
