import 'package:flutter/material.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

class EditPaymentPage extends StatelessWidget {
  final PaymentEntity payment;
  final void Function(PaymentModel updatedPayment) onSave;

  EditPaymentPage({
    required this.payment,
    required this.onSave,
  });

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _descriptionController.text = payment.description ?? '';
    _amountController.text = payment.amount.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedPayment = PaymentModel(
                    id: payment.id,
                    categoryId: payment.categoryId,
                    amount: double.tryParse(_amountController.text) ??
                        payment.amount,
                    amountFull: payment.amountFull,
                    date: payment.date,
                    isRecurring: payment.isRecurring,
                    description: _descriptionController.text,
                    numberOfPayments: 1,
                    action: 'update',
                    createAt: DateTime.now());
                onSave(updatedPayment);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
