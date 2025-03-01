part of '../../pages/home_page.dart';

void _showPaymentDialog(
    BuildContext context, String categoryName, String currentAmount) {
  //if (double.tryParse(currentAmount) == 0) return;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      DateTime selectedDate = DateTime.now();
      final TextEditingController commentsController = TextEditingController();

      return AlertDialog(
        title: const Text("Add Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Category: $categoryName"),
            const SizedBox(height: 10),
            const Text("Amount: \${currentAmount}"),
            const SizedBox(height: 10),

            // Выбор даты
            ListTile(
              title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  // setState(() {
                  //   selectedDate = pickedDate;
                  // });
                }
              },
            ),

            // Поле для комментариев
            TextField(
              controller: commentsController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Comments"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // final payment = Payment(
              //   categoryName: categoryName,
              //   amount: double.parse(currentAmount),
              //   date: selectedDate,
              //   comments: commentsController.text,
              // );
              Navigator.pop(context);
              // Здесь можно добавить логику сохранения `payment`
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
