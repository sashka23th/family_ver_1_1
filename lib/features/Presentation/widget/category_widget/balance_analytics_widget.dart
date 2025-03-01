part of '../../pages/home_page.dart';

Widget _buildBalanceAndAnalytics(
    BuildContext context,
    List<CategoryEntity> categories,
    AnalyticBloc analyticBloc,
    int familyId,
    PaymentBloc paymentBloc) {
  return Padding(
    padding: const EdgeInsets.only(left: 6, right: 6, top: 1, bottom: 1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Небольшое закругление краев
            ),
            side:
                const BorderSide(color: Colors.blue, width: 2), // Рамка кнопки
            padding: EdgeInsets.zero,
            minimumSize: const Size(70, 70), // Увеличенный размер
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnalyticsPage(
                        categories: categories,
                        familyId: familyId,
                      )),
            );
          },
          child: const Icon(Icons.analytics,
              color: Colors.blue, size: 65), // Увеличенный размер иконки
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Баланс",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            BlocBuilder<AnalyticBloc, AnalyticState>(
              builder: (context, state) {
                if (state is AnalyticLoadingState) {
                  return loadingStateWidget();
                } else if (state is AnalyticErrorState) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is AnalyticTotalLoadedState) {
                  return Text(
                    state.total, // Здесь можно подставить реальный баланс
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                } else {
                  return const Text("");
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}
