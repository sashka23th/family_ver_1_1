part of '../../pages/analytics_page.dart';

Widget _buildMonthlyBalanceChart(List<AnalyticFutureEnity> payments) {
  // Генерация данных для 30 месяцев (пример)
  List<double> monthlyBalances = payments.map((e) => e.sum).toList();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: monthlyBalances.length * 70.0, // Ширина для прокрутки
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            //  maxY: monthlyBalances.reduce((a, b) => a > b ? a : b) + 100,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                //tooltipBgColor: Colors.transparent,
                tooltipPadding: EdgeInsets.zero,
                tooltipMargin: 4,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()}',
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 200,
                  getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Месяц ${value.toInt() + 1}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(
              border: const Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            barGroups: payments.asMap().entries.map((entry) {
              final index = entry.key;
              final balance = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: balance.sum,
                    color: Colors.blueAccent,
                    width: 40,
                    borderRadius: BorderRadius.circular(4),
                    // Отображение значения над столбиком
                    backDrawRodData: BackgroundBarChartRodData(show: true),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}
