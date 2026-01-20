import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/booking/domain/entites/booking.dart';
import 'package:yaladrive/features/booking/domain/repositories/booking_repository.dart';
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
