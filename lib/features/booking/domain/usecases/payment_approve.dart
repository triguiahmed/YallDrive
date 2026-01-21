import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/features/booking/domain/repositories/booking_repository.dart';
import 'package:fpdart/fpdart.dart';

class PaymentApprove implements Usecase<void, PaymentApproveParams> {
  final BookingRepository bookingRepository;
  PaymentApprove(this.bookingRepository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await bookingRepository.paymentApprove(
      paymentStatus: params.paymentStatus,
      bookingId: params.bookingId,
    );
  }
}

class PaymentApproveParams {
  final String bookingId;
  final String paymentStatus;

  PaymentApproveParams({
    required this.bookingId,
    required this.paymentStatus,
  });
}
