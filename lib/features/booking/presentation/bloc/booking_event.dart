part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class BookCarEvent extends BookingEvent {
  final String userId;
  final String carNo;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String ownerId;

  BookCarEvent({
    required this.userId,
    required this.carNo,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.ownerId,
  });
}

class ShowBookingForOwnerEvent extends BookingEvent {
  final String ownerId;

  ShowBookingForOwnerEvent({
    required this.ownerId,
  });
}

class ShowBookingForCarEvent extends BookingEvent {
  final String carNo;

  ShowBookingForCarEvent({
    required this.carNo,
  });
}

class ShowBookingForUserEvent extends BookingEvent {
  final String userId;

  ShowBookingForUserEvent({
    required this.userId,
  });
}

class OwnerRequestApproveEvent extends BookingEvent {
  final String ownerId;
  final bool isApproved;
  final String bookingId;

  OwnerRequestApproveEvent({
    required this.bookingId,
    required this.ownerId,
    required this.isApproved,
  });
}

class PaymentApproveEvent extends BookingEvent {
  final String bookingId;
  final String paymentStatus;

  PaymentApproveEvent({
    required this.bookingId,
    required this.paymentStatus,
  });
}
