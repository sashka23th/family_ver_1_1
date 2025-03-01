part of '../../pages/analytics_page.dart';

Widget _buildMonthBalanceList({
  required List<CategoryEntity> categories,
  required AnalyticMonthEnity analyticResult,
  required Function(bool) onchange,
  required Function(int id) onDelete,
  required Function(PaymentModel payment) onUpdate,
}) {
  final Map<String, List<CategoryEntity>> groupedCategories = {};
  for (var category in categories) {
    groupedCategories
        .putIfAbsent(prefixToString(category.prefix), () => [])
        .add(category);
  }

  // Создаем мапу категорий для быстрого поиска по id
  final categoryMap = {for (var cat in categories) cat.id: cat};

  final double calculateTotalAmount = analyticResult.payments
      .where((payment) => categoryMap.containsKey(payment.categoryId))
      .map((payment) {
    final category = categoryMap[payment.categoryId]!;
    final sign = category.prefix == Prefix.exp ? -1 : 1;
    return payment.amount * sign;
  }).fold(0.0, (sum, amount) => sum + amount);
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => onchange(false),
            ),
            Text(
              formatDateString(analyticResult.period),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => onchange(true),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: groupedCategories.keys.length,
          itemBuilder: (context, index) {
            final prefix = groupedCategories.keys.elementAt(index);
            final categoriesByPrefix = groupedCategories[prefix]!;
            double totalGroupCategory = analyticResult.payments
                .where((payment) => categoriesByPrefix
                    .any((category) => category.id == payment.categoryId))
                .fold(0.0, (sum, payment) => sum + payment.amount);

            return _buildPrefixSection(
                context,
                prefix,
                categoriesByPrefix,
                analyticResult.payments,
                onDelete,
                onUpdate,
                totalGroupCategory,
                Colors.green);
          },
        ),
      ),
      const SizedBox(height: 4),
      const Divider(),
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Общий баланс:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${NumberFormat('#,##0.00 ₪').format(calculateTotalAmount)}', // Здесь вычисляй сумму
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPrefixSection(
  BuildContext context,
  String prefix,
  List<CategoryEntity> categoriesByPrefix,
  List<PaymentEntity> payments,
  Function(int id) onDelete,
  Function(PaymentModel payment) onUpdate,
  double totalGroupCategory,
  Color colorPrefix,
) {
  return ExpansionTile(
    initiallyExpanded: false,
    title: Text(
        '$prefix: ${NumberFormat('#,##0.00 ₪').format(totalGroupCategory)}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        )),
    children: categoriesByPrefix.map((category) {
      final categoryPayments = payments
          .where((payment) => payment.categoryId == category.id)
          .toList();
      final totalAmount = categoryPayments.fold(
        0.0,
        (sum, payment) => sum + payment.amount,
      );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: category.iconColor,
            child: Icon(category.icon, color: Colors.white),
          ),
          title: Text(category.name),
          subtitle: Text(NumberFormat('#,##0.00 ₪').format(totalAmount)),
          onTap: () => _openPaymentsList(
              context, category, categoryPayments, onDelete, onUpdate),
        ),
      );
    }).toList(),
  );
}

void _openPaymentsList(
  BuildContext context,
  CategoryEntity category,
  List<PaymentEntity> categoryPayments,
  Function(int id) onDelete,
  Function(PaymentModel payment) onUpdate,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentsListCategoryPage(
        category: category,
        payments: categoryPayments,
        onDelete: onDelete,
        onUpdate: onUpdate,
      ),
    ),
  );
}

class PaymentsListCategoryPage extends StatelessWidget {
  final CategoryEntity category;
  final List<PaymentEntity> payments;
  Function(int id) onDelete;
  Function(PaymentModel payment) onUpdate;

  PaymentsListCategoryPage(
      {required this.category,
      required this.payments,
      required this.onDelete,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return _CardAnalitic(
              category: category,
              payment: payment,
              context: context,
              onDelete: onDelete,
              onUpdate: onUpdate);
        },
      ),
    );
  }
}
