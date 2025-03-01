part of '../../pages/home_page.dart';

class VirtualKeyboard extends StatelessWidget {
  final int dotPressed;
  final String currentAmount;
  final String comments;
  final DateTime? selectedDate;
  final int selectedPayments;
  final VoidCallback onDotPressed; // Функция обратного вызова
  final VoidCallback onClearPressed; // Функция обратного вызова
  final VoidCallback onMinusPressed; // Функция обратного вызова
  final Function(String) onDetailsPressed; // Функция обратного вызова
  final Function(String) onNumberPressed;
  final VoidCallback onDatePressed;
  final VoidCallback onPaymentsPressed;

  const VirtualKeyboard(
      {super.key,
      required this.dotPressed,
      required this.currentAmount,
      required this.comments,
      this.selectedDate,
      required this.selectedPayments,
      required this.onDotPressed,
      required this.onClearPressed,
      required this.onMinusPressed,
      required this.onDetailsPressed,
      required this.onNumberPressed,
      required this.onDatePressed,
      required this.onPaymentsPressed});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const buttonColor = Colors.blue; // Основной цвет кнопок

    // Список кнопок с текстом, иконками и действиями
    final List<Map<String, dynamic>> buttons = [
      {
        'text': '1',
        'onPressed': () => onNumberPressed('1'),
        'isSquare': false,
      },
      {'text': '2', 'onPressed': () => onNumberPressed('2'), 'isSquare': false},
      {'text': '3', 'onPressed': () => onNumberPressed('3'), 'isSquare': false},
      {
        'text': '-',
        'color': Colors.orange,
        'onPressed': () => onMinusPressed(),
        'isSquare': true
      },
      {'text': '4', 'onPressed': () => onNumberPressed('4'), 'isSquare': false},
      {'text': '5', 'onPressed': () => onNumberPressed('5'), 'isSquare': false},
      {'text': '6', 'onPressed': () => onNumberPressed('6'), 'isSquare': false},
      {
        'text': selectedDate != null
            ? "${selectedDate!.day}"
            : "${DateTime.now().day}",
        'onPressed': () => onDatePressed(),
        'isSquare': true,
        'icon': Icons.calendar_today,
        'color': Colors.green,
      },
      {'text': '7', 'onPressed': () => onNumberPressed('7'), 'isSquare': false},
      {'text': '8', 'onPressed': () => onNumberPressed('8'), 'isSquare': false},
      {'text': '9', 'onPressed': () => onNumberPressed('9'), 'isSquare': false},
      {
        'text': (selectedPayments < 1) ? "" : "$selectedPayments пл.",
        'onPressed': () => onPaymentsPressed(),
        'isSquare': true,
        if (selectedPayments < 0) 'icon': Icons.all_inclusive,
        'color': Colors.green,
      },
      {
        'text': 'C',
        'color': Colors.red,
        'onPressed': () => onClearPressed(),
        'isSquare': false
      },
      {'text': '0', 'onPressed': () => onNumberPressed('0'), 'isSquare': false},
      {'text': '.', 'onPressed': () => onDotPressed(), 'isSquare': false},
      {
        'icon': Icons.notes,
        'text': '',
        'color': Colors.green,
        'onPressed': () => onDetailsPressed(comments),
        'isSquare': true,
      },
    ];

    return Container(
      alignment: Alignment.center,
      height: screenHeight / 3, // Ограничение высоты клавиатуры до 1/3 экрана
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Четыре кнопки в ряду
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final button = buttons[index];
          final isSquare = button['isSquare'] ?? false;

          // Квадратные кнопки для дополнительных
          return AspectRatio(
            aspectRatio: isSquare ? 1 : 3,
            child: _buildKeyboardButton(
              text: button['text'],
              icon: button['icon'],
              color: button['color'] ?? buttonColor,
              onPressed: button['onPressed'],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyboardButton({
    String? text,
    IconData? icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 4),
      ),
      onPressed: onPressed,
      child: icon != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
                // Day inside a circle
                Positioned(
                  top: 8, // Adjust position as needed
                  right: 7, // Adjust position as needed

                  child: Text(
                    '$text',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          : Text(
              text!,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
    );
  }
}
