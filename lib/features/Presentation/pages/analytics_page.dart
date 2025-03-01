import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/analytic/analytic_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/payments/payment_bloc.dart';
import 'package:family_cash/features/Presentation/widget/analitics_page/delete_payment_widget.dart';
import 'package:family_cash/features/Presentation/widget/analitics_page/edit_payment_widget.dart';
import 'package:family_cash/features/Presentation/widget/format_data_string.dart';
import 'package:family_cash/features/Presentation/widget/loading_state_widget.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';
import 'package:family_cash/features/domain/entity/analytic_month_enity.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/locator_server.dart';
import 'package:intl/intl.dart';

part '../widget/analitics_page/monthly_balance_chart_widget.dart';
part '../widget/analitics_page/recent_expenses_widgert.dart';
part '../widget/analitics_page/month_balance_widget.dart';
part '../widget/analitics_page/card_analitic.dart';

enum AnalyticsType {
  recentExpenses,
  futureBalance,
  monthlyBalance,
  recurringExpenses,
}

extension AnalyticsTypeExtension on AnalyticsType {
  String get displayName {
    switch (this) {
      case AnalyticsType.futureBalance:
        return 'Остаток по месяцам';
      case AnalyticsType.recentExpenses:
        return 'Последние 20 расходов';
      case AnalyticsType.recurringExpenses:
        return 'Постоянные расходы';
      case AnalyticsType.monthlyBalance:
        return 'Записи по месецам';
    }
  }

  IconData get icon {
    switch (this) {
      case AnalyticsType.monthlyBalance:
        return Icons.calendar_month;
      case AnalyticsType.recentExpenses:
        return Icons.list;
      case AnalyticsType.recurringExpenses:
        return Icons.all_inclusive;
      case AnalyticsType.futureBalance:
        return Icons.trending_down;
    }
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String iconName;
  final Color iconColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.iconColor,
  });
}

// Здесь добавь модели CategoryModel, PaymentModel и PaymentBloc

class AnalyticsPage extends StatefulWidget {
  final List<CategoryEntity> categories;
  final int familyId;

  const AnalyticsPage({
    super.key,
    required this.categories,
    required this.familyId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final analyticBloc = sl<AnalyticBloc>();
  final paymentBloc = sl<PaymentBloc>();
  AnalyticsType selectedAnalyticsType = AnalyticsType.monthlyBalance;
  // ignore: unused_field
  late TabController _tabController;
  int fromMonth = 1;

  @override
  void initState() {
    super.initState();
    // analyticBloc.add(GetMonthEvent(familyId: widget.familyId, fromMonth: 1));
    analyticBloc
        .add(GetMonthEvent(familyId: widget.familyId, fromMonth: fromMonth));
  }

  @override
  void dispose() {
    //_tabController.dispose();
    super.dispose();
  }

  void _runAnalytic(AnalyticsType value) {
    switch (value) {
      case AnalyticsType.futureBalance:
        analyticBloc.add(GetFurureEvent(familyId: widget.familyId));
      case AnalyticsType.recentExpenses:
        analyticBloc.add(GetLastLimitEvent(familyId: widget.familyId));
      case AnalyticsType.recurringExpenses:
        analyticBloc.add(GetRecurringEvent(familyId: widget.familyId));
      case AnalyticsType.monthlyBalance:
        analyticBloc.add(
            GetMonthEvent(familyId: widget.familyId, fromMonth: fromMonth));
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    void onChanged(AnalyticsType? newValue) {
      if (newValue != null) {
        selectedAnalyticsType = newValue;
        setState(() {
          _runAnalytic(newValue);
        });
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => analyticBloc,
        ),
        BlocProvider(
          create: (context) => paymentBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc84040),
          //title: const Text('Аналитика'),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<AnalyticsType>(
                value: selectedAnalyticsType,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: const Color.fromARGB(255, 140, 143, 150),
                onChanged: onChanged,
                items: AnalyticsType.values.map((AnalyticsType type) {
                  return DropdownMenuItem<AnalyticsType>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(type.displayName,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            //_buildAnalyticsTypeSelector(),
            Expanded(
              // child: Container(),
              child: BlocListener<PaymentBloc, PaymentState>(
                listener: (context, statePayment) async {
                  if (statePayment is PaymentDeletedState) {
                    _runAnalytic(selectedAnalyticsType);
                  }
                },
                child: BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, statePayment) {
                    return BlocBuilder<AnalyticBloc, AnalyticState>(
                      builder: (context, state) {
                        if (state is AnalyticLoadingState ||
                            statePayment is PaymentsLoadingState) {
                          return loadingStateWidget();
                        } else if (state is AnalyticLastLimitState) {
                          return _buildPaymentList(widget.categories,
                              state.analyticPayments, widget.familyId, (id) {
                            paymentBloc.add(
                              DeletePaymentsEvent(id: id),
                            );
                          }, (payment) {
                            paymentBloc.add(
                                UpdatePaymentsEvent(paymentModel: payment));
                          });
                        } else if (state is AnalyticFutureLoadedState) {
                          return _buildMonthlyBalanceChart(
                              state.analyticFuture);
                        } else if (state is AnalyticRecurringLoadedState) {
                          return _buildPaymentList(
                            widget.categories,
                            state.analyticRecurring,
                            widget.familyId,
                            (id) =>
                                paymentBloc.add(DeletePaymentsEvent(id: id)),
                            (payment) => paymentBloc.add(
                                UpdatePaymentsEvent(paymentModel: payment)),
                            isSoft: true
                          );
                        } else if (state is AnalyticMonthLoadedState) {
                          return _buildMonthBalanceList(
                              categories: widget.categories,
                              analyticResult: state.analyticMonth,
                              onchange: (change) {
                                setState(() {
                                  if (change) {
                                    fromMonth++;
                                  } else {
                                    fromMonth--;
                                  }
                                });
                              },
                              onDelete: (id) {
                                paymentBloc.add(
                                  DeletePaymentsEvent(id: id),
                                );
                              },
                              onUpdate: (payment) {
                                paymentBloc.add(
                                    UpdatePaymentsEvent(paymentModel: payment));

                                analyticBloc.add(GetMonthEvent(
                                    familyId: widget.familyId,
                                    fromMonth: fromMonth));
                              });
                        } else if (state is AnalyticErrorState) {
                          return Center(child: Text(state.message));
                        } else if (state is AnalyticEmptyState) {
                          return Container();
                          // return _buildAnalyticsContent(state.payments);
                        } else {
                          return const Center(
                              child: Text('Ошибка загрузки платежей'));
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildAnalyticsTypeSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            AnalyticsType.values.map((type) => _buildTypeButton(type)).toList(),
      ),
    );
  }

  Widget _buildTypeButton(AnalyticsType type) {
    return ElevatedButton(
      onPressed: () => setState(() {
        selectedAnalyticsType = type;
      }),
      child: Text(type.displayName),
    );
  }

  // ignore: unused_element
  Widget _buildRecurringExpensesList(List<PaymentEntity> payments) {
    final recurringPayments =
        payments.where((p) => p.numberOfPayments == -1).toList();

    if (recurringPayments.isEmpty) {
      return const Center(child: Text('Постоянные расходы не найдены'));
    }

    return ListView.builder(
      itemCount: recurringPayments.length,
      itemBuilder: (context, index) {
        final payment = recurringPayments[index];
        return ListTile(
          title: Text(payment.description ?? ''),
          subtitle: Text('${payment.amount} ₽, ${payment.date.toLocal()}'),
        );
      },
    );
  }
}
