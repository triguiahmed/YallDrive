import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource bookingRemoteDataSource;
  BookingRepositoryImpl(this.bookingRemoteDataSource);

  @override
  Future<Either<Failure, void>> bookingCar({
    required String userId,
    required String carNo,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String ownerId,
  }) async {
    try {
      await bookingRemoteDataSource.bookingCar(
        userId: userId,
        carNo: carNo,
        startDate: startDate,
        endDate: endDate,
        price: price,
        ownerId: ownerId,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> ownerRequestApprove({
    required String ownerId,
    required bool isApproved,
    required String bookingId,
  }) async {
    try {
      await bookingRemoteDataSource.ownerRequestApprove(
        ownerId: ownerId,
        isApproved: isApproved,
        bookingId: bookingId,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> showBookingForCar({
    required String carNo,
  }) async {
    try {
      final bookings = await bookingRemoteDataSource.showBookingForCar(
        carNo: carNo,
      );
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> showBookingForOwner({
    required String ownerId,
  }) async {
    try {
      final bookings = await bookingRemoteDataSource.showBookingForOwner(
        ownerId: ownerId,
      );
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> showBookingForUser({
    required String userId,
  }) async {
    try {
      final bookings = await bookingRemoteDataSource.showBookingForUser(
        userId: userId,
      );
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> paymentApprove({
    required String paymentStatus,
    required String bookingId,
  }) async {
    try {
      await bookingRemoteDataSource.paymentApprove(
        bookingId: bookingId,
        paymentStatus: paymentStatus,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
