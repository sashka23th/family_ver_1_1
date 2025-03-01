part of '../../pages/analytics_page.dart';

Widget _buildPaymentList(
    List<CategoryEntity> categories,
    List<PaymentEntity> payments,
    int familyId,
    Function(int id) onDelete,
    Function(PaymentModel payment) onUpdate,
    {bool isSoft = false}) {
  if (isSoft)
    payments.sort((a, b) {
      int idComparison = a.categoryId.compareTo(b.categoryId);
      if (idComparison != 0) {
        return idComparison;
      }
      return (a.description ?? '').compareTo(b.description ?? '');
    });

  return ListView.builder(
    itemCount: payments.length,
    itemBuilder: (context, index) {
      final payment = payments[index];
      final CategoryEntity category = categories
              .where((category) => category.id == payment.categoryId)
              .firstOrNull ??
          const CategoryEntity(
              iconColor: Colors.black,
              id: -1,
              familyId: -1,
              name: "No Category",
              prefix: Prefix.exp,
              details: '',
              icon: Icons.error);
      return _CardAnalitic(
          category: category,
          payment: payment,
          onDelete: onDelete,
          onUpdate: onUpdate,
          context: context);
    },
  );
}
