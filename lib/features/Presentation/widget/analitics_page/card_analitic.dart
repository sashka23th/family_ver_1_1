part of '../../pages/analytics_page.dart';

void _showSnackBar(BuildContext context, CategoryEntity category) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      'Категория: ${category.name}',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: category.iconColor, // Прозрачный фон
    //elevation: 0, // Убираем тень
    behavior: SnackBarBehavior.floating, // Плавающий эффект
    duration: Duration(seconds: 1), // Длительность 1 секунда),
  ));
}

Widget _CardAnalitic(
    {required CategoryEntity category,
    required PaymentEntity payment,
    required BuildContext context,
    required Function(int id) onDelete,
    required Function(PaymentModel payment) onUpdate}) {
  return Stack(
    children: [
      Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => _showSnackBar(context, category),
            child: CircleAvatar(
              backgroundColor: category.iconColor,
              child: Icon(category.icon, color: Colors.white),
            ),
          ),
          title:
              (payment.description != null) ? Text(payment.description!) : null,
          subtitle: (payment.numberOfPayments > 1)
              ? Text(
                  'Сумма: ${NumberFormat('#,##0.00 ₪').format(payment.amount)} \n'
                  'Дата: ${formatDateString(payment.date)} \nСоздан: ${formatDateAndTimeString(payment.createAt)} \n'
                  'Платеж: ${payment.installment} из ${payment.numberOfPayments}')
              : Text(
                  'Сумма: ${NumberFormat('#,##0.00 ₪').format(payment.amount)} \n'
                  'Дата: ${formatDateString(payment.date)} \nСоздан: ${formatDateAndTimeString(payment.createAt)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => editPayment(context, payment, onUpdate),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePayment(context, payment, onDelete),
              ),
            ],
          ),
        ),
      ),
      if (payment.isRecurring)
        Positioned(
            top: 8, // Отступ сверху
            right: 26, // Отступ справа
            child:
                Icon(Icons.all_inclusive, color: Color(0xff493a39), size: 16)),
    ],
  );
}
