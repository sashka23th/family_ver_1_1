part of '../../pages/home_page.dart';

Widget _buildAmountField(String currentAmount) {
  return Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      //color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      currentAmount,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    ),
  );
}
