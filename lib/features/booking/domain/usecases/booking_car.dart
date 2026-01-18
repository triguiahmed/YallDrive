import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';

class BookingCar implements Usecase<void, BookingCarParams> {
  final BookingRepository bookingRepository;
  BookingCar(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(BookingCarParams params) async {
    return await bookingRepository.bookingCar(
      userId: params.userId,
      carNo: params.carNo,
      startDate: params.startDate,
      endDate: params.endDate,
      price: params.price,
      ownerId: params.ownerId,
    );
  }
}

class BookingCarParams {
  final String userId;
  final String carNo;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String ownerId;

  BookingCarParams({
    required this.userId,
    required this.carNo,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.ownerId,
  });
}
