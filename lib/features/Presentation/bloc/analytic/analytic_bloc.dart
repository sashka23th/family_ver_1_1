import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_cash/features/domain/entity/analytic_future_enity.dart';
import 'package:family_cash/features/domain/entity/analytic_month_enity.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/features/domain/usecases/analytic_usecase.dart';
import 'package:intl/intl.dart';

part 'analytic_event.dart';
part 'analytic_state.dart';

class AnalyticBloc extends Bloc<AnalyticEvent, AnalyticState> {
  final AnalyticUsecase analyticUsecase;

  AnalyticBloc({required this.analyticUsecase}) : super(AnalyticEmptyState()) {
    on<GetTotalEvent>((event, emit) async {
      final startTime = DateTime.now();
      emit(AnalyticLoadingState());

      final failOrTotal = await analyticUsecase.getTotalSum(event.familyId);
      failOrTotal
          .fold((l) => emit(AnalyticErrorState(message: l.message.toString())),
              (total) {
        String toatalString = NumberFormat('#,##0 ₪').format(total);
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime).inMilliseconds;

        print('BLoC processing time: ${duration} ms');
        emit(AnalyticTotalLoadedState(total: toatalString));
      });
    });

    on<GetFurureEvent>((event, emit) async {
      emit(AnalyticLoadingState());
      final failOrResult = await analyticUsecase.getFutureSum(event.familyId);
      failOrResult.fold(
          (l) => emit(AnalyticErrorState(message: l.message.toString())), (r) {
        emit(AnalyticFutureLoadedState(analyticFuture: r));
      });
    });

    on<GetRecurringEvent>((event, emit) async {
      emit(AnalyticLoadingState());
      final failOrResult =
          await analyticUsecase.getRecurringPayments(event.familyId);
      failOrResult.fold(
          (l) => emit(AnalyticErrorState(message: l.message.toString())), (r) {
        emit(AnalyticRecurringLoadedState(analyticRecurring: r));
      });
    });

    on<GetLastLimitEvent>((event, emit) async {
      emit(AnalyticLoadingState());
      final failOrResult =
          await analyticUsecase.getLastPayments(event.familyId, 20);
      failOrResult.fold(
          (l) => emit(AnalyticErrorState(message: l.message.toString())), (r) {
        emit(AnalyticLastLimitState(analyticPayments: r));
      });
    });

    on<GetMonthEvent>((event, emit) async {
      emit(AnalyticLoadingState());
      final failOrResult = await analyticUsecase.getMonthPayments(
          event.familyId, event.fromMonth);
      failOrResult.fold(
          (l) => emit(AnalyticErrorState(message: l.message.toString())), (r) {
        emit(AnalyticMonthLoadedState(analyticMonth: r));
      });
    });
  }
}
