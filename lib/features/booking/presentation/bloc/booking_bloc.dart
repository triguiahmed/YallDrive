import 'package:bloc/bloc.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/booking_car.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/owner_request_approve.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/payment_approve.dart';

import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/show_booking_for_car.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/show_booking_for_owner.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/usecases/show_booking_for_user.dart';
import 'package:flutter/material.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingCar _bookingCar;
  final OwnerRequestApprove _ownerRequestApprove;
  final ShowBookingForCar _bookingForCar;
  final ShowBookingForOwner _bookingForOwner;
  final ShowBookingForUser _bookingForUser;
  final PaymentApprove _paymentApprove;

  BookingBloc({
    required BookingCar bookingCar,
    required OwnerRequestApprove ownerRequestApprove,
    required ShowBookingForCar bookingForCar,
    required ShowBookingForOwner bookingForOwner,
    required ShowBookingForUser bookingForUser,
    required PaymentApprove paymentApprove,
  })  : _bookingCar = bookingCar,
        _ownerRequestApprove = ownerRequestApprove,
        _bookingForCar = bookingForCar,
        _bookingForOwner = bookingForOwner,
        _bookingForUser = bookingForUser,
        _paymentApprove = paymentApprove,
        super(BookingInitial()) {
    on<BookingEvent>((event, emit) => emit(BookingLoading()));
    on<BookCarEvent>(_bookingEvent);
    on<ShowBookingForOwnerEvent>(_bookingForOwnerEvent);
    on<ShowBookingForCarEvent>(_bookingForCarEvent);
    on<ShowBookingForUserEvent>(_bookingForUserEvent);
    on<OwnerRequestApproveEvent>(_ownerRequestApproveEvent);
    on<PaymentApproveEvent>(_paymentApproveEvent);
  }

  void _bookingEvent(
    BookCarEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _bookingCar(
      BookingCarParams(
        userId: event.userId,
        carNo: event.carNo,
        startDate: event.startDate,
        endDate: event.endDate,
        price: event.price,
        ownerId: event.ownerId,
      ),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (booking) => emit(BookingSuccess()),
    );
  }

  void _bookingForOwnerEvent(
    ShowBookingForOwnerEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _bookingForOwner(
      ShowBookingForOwnerParams(ownerId: event.ownerId),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (bookings) => emit(BookingSuccessListBooking(bookings)),
    );
  }

  void _bookingForCarEvent(
    ShowBookingForCarEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _bookingForCar(
      ShowBookingForCarParams(carNo: event.carNo),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (bookings) => emit(BookingSuccessListBooking(bookings)),
    );
  }

  void _bookingForUserEvent(
    ShowBookingForUserEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _bookingForUser(
      ShowBookingForUserParams(userId: event.userId),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (bookings) => emit(BookingSuccessListBooking(bookings)),
    );
  }

  void _ownerRequestApproveEvent(
    OwnerRequestApproveEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _ownerRequestApprove(
      OwnerRequestApproveParams(
          ownerId: event.ownerId,
          isApproved: event.isApproved,
          bookingId: event.bookingId),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (booking) => emit(BookingSuccess()),
    );
  }

  void _paymentApproveEvent(
    PaymentApproveEvent event,
    Emitter<BookingState> emit,
  ) async {
    final res = await _paymentApprove(
      PaymentApproveParams(
        bookingId: event.bookingId,
        paymentStatus: event.paymentStatus,
      ),
    );

    res.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (booking) => emit(BookingSuccess()),
    );
  }
}
