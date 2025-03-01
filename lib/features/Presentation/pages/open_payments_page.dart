import 'package:flutter/material.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

class OpenPaymentsPage extends StatelessWidget {
  final List<PaymentsOpenEntity> payments;
  final Function() onClick;

  OpenPaymentsPage({required this.payments, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments List'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return ListTile(
            leading: const Icon(Icons.monetization_on),
            title: Text(
                'Category: ${payment.categoryId}, Amount: \$${payment.amount}'),
            subtitle: Text(
                'Date: ${payment.date.toLocal()} | Action: ${payment.action}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.settings), onPressed: () => onClick),
    );
  }
}
