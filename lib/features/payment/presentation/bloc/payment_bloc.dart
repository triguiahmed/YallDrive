import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/usecases/create_payment.dart';
import 'package:yaladrive/features/payment/domain/usecases/delete_payment.dart';
import 'package:yaladrive/features/payment/domain/usecases/get_payment_for_booking.dart';
import 'package:yaladrive/features/payment/domain/usecases/get_payments_by_user.dart';
import 'package:yaladrive/features/payment/domain/usecases/update_payment_status.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePayment _createPayment;
  final GetPaymentForBooking _getPaymentForBooking;
  final GetPaymentsByUser _getPaymentsByUser;
  final UpdatePaymentStatus _updatePaymentStatus;
  final DeletePayment _deletePayment;

  PaymentBloc({
    required CreatePayment createPayment,
    required GetPaymentForBooking getPaymentForBooking,
    required GetPaymentsByUser getPaymentsByUser,
    required UpdatePaymentStatus updatePaymentStatus,
    required DeletePayment deletePayment,
  })  : _createPayment = createPayment,
        _getPaymentForBooking = getPaymentForBooking,
        _getPaymentsByUser = getPaymentsByUser,
        _updatePaymentStatus = updatePaymentStatus,
        _deletePayment = deletePayment,
        super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
    on<GetPaymentForBookingEvent>(_onGetPaymentForBooking);
    on<GetPaymentsByUserEvent>(_onGetPaymentsByUser);
    on<UpdatePaymentStatusEvent>(_onUpdatePaymentStatus);
    on<DeletePaymentEvent>(_onDeletePayment);
  }

  Future<void> _onCreatePayment(
    CreatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await _createPayment(
      CreatePaymentParams(
        bookingId: event.bookingId,
        userId: event.userId,
        amount: event.amount,
        method: event.method,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payment) => emit(PaymentCreated(payment: payment)),
    );
  }

  Future<void> _onGetPaymentForBooking(
    GetPaymentForBookingEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await _getPaymentForBooking(
      GetPaymentForBookingParams(bookingId: event.bookingId),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payment) => emit(PaymentLoaded(payment: payment)),
    );
  }

  Future<void> _onGetPaymentsByUser(
    GetPaymentsByUserEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await _getPaymentsByUser(
      GetPaymentsByUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payments) => emit(PaymentsLoaded(payments: payments)),
    );
  }

  Future<void> _onUpdatePaymentStatus(
    UpdatePaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await _updatePaymentStatus(
      UpdatePaymentStatusParams(
        paymentId: event.paymentId,
        userId: event.userId,
        newStatus: event.newStatus,
      ),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (payment) => emit(PaymentUpdated(payment: payment)),
    );
  }

  Future<void> _onDeletePayment(
    DeletePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    final result = await _deletePayment(
      DeletePaymentParams(
        paymentId: event.paymentId,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => emit(PaymentError(message: failure.message)),
      (_) => emit(PaymentDeleted()),
    );
  }
}
