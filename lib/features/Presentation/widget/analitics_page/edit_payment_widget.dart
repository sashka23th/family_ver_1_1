import 'package:flutter/material.dart';
import 'package:family_cash/features/Presentation/pages/payment_page.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';

void editPayment(BuildContext context, PaymentEntity payment,
    Function(PaymentModel) onSave) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditPaymentPage(payment: payment, onSave: onSave),
    ),
  );
}
