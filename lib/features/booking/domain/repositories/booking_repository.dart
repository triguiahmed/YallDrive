import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BookingRepository {
  Future<Either<Failure, void>> bookingCar({
    required String userId,
    required String carNo,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String ownerId,
  });

  Future<Either<Failure, List<Booking>>> showBookingForOwner({
    required String ownerId,
  });

  Future<Either<Failure, List<Booking>>> showBookingForCar({
    required String carNo,
  });

  Future<Either<Failure, List<Booking>>> showBookingForUser({
    required String userId,
  });

  Future<Either<Failure, void>> ownerRequestApprove({
    required String ownerId,
    required bool isApproved,
    required String bookingId,
  }); 

  Future<Either<Failure, void>>paymentApprove({
    required String paymentStatus,
    required String bookingId,
  });
}
