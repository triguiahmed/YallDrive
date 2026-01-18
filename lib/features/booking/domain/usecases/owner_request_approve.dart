import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';

class OwnerRequestApprove implements Usecase<void, OwnerRequestApproveParams> {
  final BookingRepository bookingRepository;
  OwnerRequestApprove(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(OwnerRequestApproveParams params) async {
    return await bookingRepository.ownerRequestApprove(
      ownerId: params.ownerId,
      isApproved: params.isApproved,
      bookingId: params.bookingId,
    );
  }
}

class OwnerRequestApproveParams {
  final String ownerId;
  final bool isApproved;
  final String bookingId;

  OwnerRequestApproveParams({
    required this.ownerId,
    required this.isApproved,
    required this.bookingId,
  });
}
