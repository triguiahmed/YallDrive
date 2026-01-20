import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentForBooking implements Usecase<Payment?, GetPaymentForBookingParams> {
  final PaymentRepository paymentRepository;

  GetPaymentForBooking(this.paymentRepository);

  @override
  Future<Either<Failure, Payment?>> call(GetPaymentForBookingParams params) async {
    return await paymentRepository.getPaymentForBooking(
      bookingId: params.bookingId,
    );
  }
}

class GetPaymentForBookingParams {
  final String bookingId;

  GetPaymentForBookingParams({
    required this.bookingId,
  });
}
