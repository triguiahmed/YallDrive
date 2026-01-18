import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';

class ShowBookingForUser
    implements Usecase<List<Booking>, ShowBookingForUserParams> {
  final BookingRepository bookingRepository;
  ShowBookingForUser(this.bookingRepository);
  @override
  Future<Either<Failure, List<Booking>>> call(
      ShowBookingForUserParams params) async {
    return await bookingRepository.showBookingForUser(
      userId: params.userId,
    );
  }
}

class ShowBookingForUserParams {
  final String userId;
  ShowBookingForUserParams({
    required this.userId,
  });
}