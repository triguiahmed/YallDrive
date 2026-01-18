import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';


class ShowBookingForOwner
    implements Usecase<List<Booking>, ShowBookingForOwnerParams> {
  final BookingRepository bookingRepository;
  ShowBookingForOwner(this.bookingRepository);

  @override
  Future<Either<Failure, List<Booking>>> call(
      ShowBookingForOwnerParams params) async {
    return await bookingRepository.showBookingForOwner(
      ownerId: params.ownerId,
    );
  }
}

class ShowBookingForOwnerParams {
  final String ownerId;

  ShowBookingForOwnerParams({
    required this.ownerId,
  });
}
