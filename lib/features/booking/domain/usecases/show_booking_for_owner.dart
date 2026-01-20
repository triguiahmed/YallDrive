import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/booking/domain/entites/booking.dart';
import 'package:yaladrive/features/booking/domain/repositories/booking_repository.dart';
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
