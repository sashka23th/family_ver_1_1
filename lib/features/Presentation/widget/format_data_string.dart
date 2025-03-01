import 'package:intl/intl.dart';

String formatDateString(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String formatDateAndTimeString(DateTime date) {
  return DateFormat('dd/MM HH:mm').format(date);
}
