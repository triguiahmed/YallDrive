part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentCreated extends PaymentState {
  final Payment payment;

  PaymentCreated({required this.payment});
}

final class PaymentLoaded extends PaymentState {
  final Payment? payment;

  PaymentLoaded({this.payment});
}

final class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;

  PaymentsLoaded({required this.payments});
}

final class PaymentUpdated extends PaymentState {
  final Payment payment;

  PaymentUpdated({required this.payment});
}

final class PaymentDeleted extends PaymentState {}

final class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});
}
