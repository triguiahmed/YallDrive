part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);
}

final class BookingSuccess extends BookingState {}

final class BookingSuccessListBooking extends BookingState {
  final List<Booking> bookings;
  BookingSuccessListBooking(this.bookings);
}
