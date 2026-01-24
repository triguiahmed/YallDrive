part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

final class CreatePaymentEvent extends PaymentEvent {
  final String bookingId;
  final String userId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;

  CreatePaymentEvent({
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.method,
    this.status = PaymentStatus.pending,
  });
}

final class GetPaymentForBookingEvent extends PaymentEvent {
  final String bookingId;

  GetPaymentForBookingEvent({
    required this.bookingId,
  });
}

final class GetPaymentsByUserEvent extends PaymentEvent {
  final String userId;

  GetPaymentsByUserEvent({
    required this.userId,
  });
}

final class UpdatePaymentStatusEvent extends PaymentEvent {
  final String paymentId;
  final String userId;
  final PaymentStatus newStatus;

  UpdatePaymentStatusEvent({
    required this.paymentId,
    required this.userId,
    required this.newStatus,
  });
}

final class DeletePaymentEvent extends PaymentEvent {
  final String paymentId;
  final String userId;

  DeletePaymentEvent({
    required this.paymentId,
    required this.userId,
  });
}
