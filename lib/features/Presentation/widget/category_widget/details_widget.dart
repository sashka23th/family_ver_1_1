part of '../../pages/home_page.dart';

Widget _buildDetailsField(int selectedPayments,
    String Function() getEachPaymentText, String comments) {
  String txt = 'Коментарии: ';
  if (selectedPayments > 1) txt += "${getEachPaymentText()} ";
  txt += comments.isEmpty ? " нету" : " $comments";

  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          txt,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    ),
  );
}
