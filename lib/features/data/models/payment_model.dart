// Генерация тестовых данных платежей
import 'package:family_cash/features/data/models/analytic_future_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

class PaymentModel extends PaymentsOpenEntity {
  PaymentModel(
      {required super.categoryId,
      required super.amount,
      required super.date,
      required super.id,
      required super.amountFull,
      required super.isRecurring,
      required super.numberOfPayments,
      super.description,
      super.installment,
      required super.action,
      required super.createAt});

  // Фабричный метод для создания объекта Payment из JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    int installment = 1;
    int inumberOfPayments = 1;
    if (json.containsKey('periud')) {
      String period = json['periud'].toString();
      List<String> parts = period.split('/'); // Разбиваем строку по символу '/'
      if (parts.length > 1) {
        installment =
            int.tryParse(parts[0]) ?? 1; // Преобразуем первую часть в int
        inumberOfPayments =
            int.tryParse(parts[1]) ?? 1; // Преобразуем вторую часть в int
      }
    }

    bool returnRecurring(dynamic isRecurring) {
      if (isRecurring is bool) {
        return isRecurring;
      } else if (isRecurring is int) {
        return (isRecurring == 1) ? true : false;
      } else {
        return false;
      }
    }

    late DateTime createdAt;
    if (json.containsKey('created_at')) {
      createdAt = DateTime.tryParse(json['created_at']) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return PaymentModel(
        id: json['id'],
        description: json['details'],
        date: DateTime.parse(json['ddate']),
        numberOfPayments: inumberOfPayments,
        installment: installment,
        isRecurring: returnRecurring(json['is_default']),
        categoryId: json['category_id'],
        amount: returnDouble(json['sum']),
        amountFull: (json.containsKey('sum_full'))
            ? returnDouble(json['sum_full'])
            : returnDouble(json['sum']),
        action: json.containsKey("action") ? json['action'] : 'None',
        createAt: createdAt);
  }

  // Метод для преобразования объекта Payment в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'sum': amount,
      'sum_full': amountFull,
      'ddate': date.toIso8601String(),
      'details': description,
      'periud': numberOfPayments,
      'is_default': isRecurring,
      'action': action
    };
  }
}
