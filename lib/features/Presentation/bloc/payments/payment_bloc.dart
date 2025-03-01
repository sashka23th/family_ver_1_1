import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/payment_entity.dart';
import 'package:family_cash/features/domain/usecases/payment_usecase.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUsecase paymentUsecase;

  PaymentBloc({required this.paymentUsecase}) : super(PaymentsEmptyState()) {
    on<AddPaymentsEvent>((event, emit) async {
      emit(PaymentsLoadingState());
      await paymentUsecase.addPayment(event.paymentModel);
      emit(const PaymentsMassageState(message: "payment added"));
    });

    on<UpdatePaymentsEvent>((event, emit) async {
      emit(PaymentsLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await paymentUsecase.updatePayment(event.paymentModel);
      emit(const PaymentsMassageState(message: "payment updated"));
    });

    on<DeletePaymentsEvent>((event, emit) async {
      emit(PaymentsLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await paymentUsecase.deletePayment(event.id);
      emit(PaymentDeletedState());
    });

    on<OpenPaymentsEvent>((event, emit) async {
      emit(PaymentsLoadingState());
      final payments = await paymentUsecase.openPayments();
      payments.fold((l) => emit(PaymentsMassageState(message: l.message)),
          (r) => emit(PaymentsLoadedState(payments: r)));
    });

    on<RefreshPaymentsEvent>((event, emit) async {
      emit(PaymentsLoadingState());
      final payments = await paymentUsecase.refresfPayments();
      payments.fold((l) => emit(PaymentsMassageState(message: l.message)),
          (r) => emit(const PaymentsMassageState(message: "Refreshed")));
    });
  }
}
