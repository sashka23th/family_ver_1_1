part of '../../pages/home_page.dart';

class ApplicationMainForm extends StatefulWidget {
  final List<CategoryEntity> categories;
  final int familyDefault;
  final CategoryBloc categoryBloc;
  final PaymentBloc paymentBloc;
  final AnalyticBloc analyticBloc;

  const ApplicationMainForm(
      {super.key,
      required this.categories,
      required this.familyDefault,
      required this.categoryBloc,
      required this.paymentBloc,
      required this.analyticBloc});

  @override
  _ApplicationMainForm createState() => _ApplicationMainForm();
}

class _ApplicationMainForm extends State<ApplicationMainForm> {
  String currentAmount = '0.00';
  double currentAmountDouble = 0.00;
  int dotPressed = 0;
  String comments = ''; // Переменная для хранения комментариев
  DateTime? selectedDate;
  int selectedPayments = 1;
  String getEachPaymentText() {
    if (selectedPayments <= 1) {
      return ''; // Не отображаем текст, если один платеж
    }

    final double? totalAmount =
        double.tryParse(currentAmount.replaceAll(',', ''));
    if (totalAmount == null || totalAmount == 0) return '';

    final eachPayment = totalAmount / selectedPayments;
    return "${formatAmount(eachPayment.toString())} ежемесечно.";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = DateTime.now();
    });
  }

// Метод для обработки точки (десятичной запятой)
  void _onDotPressed() {
    setState(() {
      dotPressed++;
    });
  }

// Метод для сброса значения
  void _onClearPressed() {
    setState(() {
      currentAmountDouble = 0.00;
      currentAmount = '0.00';
      dotPressed = 0;
      comments = '';
      selectedDate = DateTime.now();
    });
  }

  void _onUpdateComments(String newComments) {
    setState(() {
      comments = newComments;
    });
  }

  void _onDatePressed() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _onMinusPressed() {
    setState(() {
      currentAmountDouble = currentAmountDouble * -1;
      if (!currentAmount.startsWith('-')) {
        currentAmount = '-$currentAmount';
      } else {
        currentAmount = currentAmount.substring(1);
      }
    });
  }

  // Метод для обработки нажатия цифровой кнопки
  void _onNumberPressed(String number) {
    setState(() {
      if (currentAmount == '0.00' && dotPressed == 0) {
        currentAmount = number;
        currentAmountDouble = double.parse(number);
      } else {
        // Проверяем, чтобы было не больше двух знаков после запятой
        final parts = currentAmount.split('.');
        if (parts.length == 2 && dotPressed > 2) return;

        currentAmount = (dotPressed > 0)
            ? '${parts[0]}.${int.parse(parts[1]).toString() + number}'
            : '${parts[0]}$number.${parts[1]}';
      }
      currentAmount = formatAmount(currentAmount.replaceAll(',', ''));
      if (dotPressed > 0) _onDotPressed();
    });
  }

// Метод для обновления комментариев
  void _onDetailsPressed(String comments) async {
    final FocusNode focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    final newComment = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller =
            TextEditingController(text: comments);

        return AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            focusNode: focusNode,
            maxLines: 3,
            decoration:
                const InputDecoration(hintText: "Enter comments here 2"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
        // Устанавливаем фокус после построения диалога
      },
    );

    if (newComment != null && newComment.isNotEmpty) {
      _onUpdateComments(newComment);
    }
  }

  void _onPaymentsPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Number of Payments"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор количества платежей
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Payments"),
                onChanged: (value) {
                  setState(() {
                    selectedPayments = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Повторяющаяся запись
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Условное значение для повторяющейся записи
                    selectedPayments = -1;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Set as Recurring"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onSavePayment(int i) {
    final String name = widget.categories[i].name;
    final amount = double.tryParse(currentAmount.replaceAll(',', '')) ?? 0;
    widget.paymentBloc.add(AddPaymentsEvent(
        paymentModel: PaymentModel(
            categoryId: widget.categories[i].id,
            amount: amount,
            date: selectedDate!,
            id: -1,
            amountFull: amount,
            isRecurring: selectedPayments == -1 ? true : false,
            numberOfPayments: selectedPayments == -1 ? 1 : selectedPayments,
            action: 'insert',
            description: comments,
            createAt: DateTime.now())));
    _onClearPressed();
    widget.analyticBloc.add(GetTotalEvent(familyId: widget.familyDefault));
    widget.paymentBloc.add(OpenPaymentsEvent());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Сохранаем ${formatAmount(amount.toString())} в катигории: $name"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.categories.sort((a, b) => a.prefix.index.compareTo(b.prefix.index));
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            _buildBalanceAndAnalytics(context, widget.categories,
                widget.analyticBloc, widget.familyDefault, widget.paymentBloc),
            const Divider(),
            _buildCategoriesGrid(context, widget.categories, currentAmount,
                widget.familyDefault, _onSavePayment, widget.categoryBloc),
            const Divider(),
            _buildAmountField(currentAmount),
            const SizedBox(height: 4),
            _buildDetailsField(selectedPayments, getEachPaymentText, comments),
          ],
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: VirtualKeyboard(
            dotPressed: dotPressed,
            onDotPressed: _onDotPressed,
            currentAmount: currentAmount,
            comments: comments,
            selectedPayments: selectedPayments,
            selectedDate: selectedDate,
            onClearPressed: _onClearPressed,
            onMinusPressed: _onMinusPressed,
            onDetailsPressed: _onDetailsPressed,
            onNumberPressed: _onNumberPressed,
            onDatePressed: _onDatePressed,
            onPaymentsPressed: _onPaymentsPressed,
          ),
        ),
      ],
    );
  }
}
