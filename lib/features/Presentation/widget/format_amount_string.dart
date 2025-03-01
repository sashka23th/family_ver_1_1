// Метод для форматирования суммы в формате x,xxx.xx
import 'package:intl/intl.dart';

String formatAmount(String amount) {
  final double? parsedAmount = double.tryParse(amount);
  if (parsedAmount == null) return '0.00';

  // Используем NumberFormat для форматирования суммы
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return formatter.format(parsedAmount);
}
