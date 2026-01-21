import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/features/booking/domain/entites/booking.dart';
import 'package:yalladrive/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';


class ShowBookingForCar
    implements Usecase<List<Booking>, ShowBookingForCarParams> {
  final BookingRepository bookingRepository;
  ShowBookingForCar(this.bookingRepository);

  @override
  Future<Either<Failure, List<Booking>>> call(
      ShowBookingForCarParams params) async {
    return await bookingRepository.showBookingForCar(
      carNo: params.carNo,
    );
  }
}

class ShowBookingForCarParams {
  final String carNo;

  ShowBookingForCarParams({
    required this.carNo,
  });
}
