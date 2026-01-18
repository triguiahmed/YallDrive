import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
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
