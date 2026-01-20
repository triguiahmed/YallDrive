import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class CreatePayment implements Usecase<Payment, CreatePaymentParams> {
  final PaymentRepository paymentRepository;

  CreatePayment(this.paymentRepository);

  @override
  Future<Either<Failure, Payment>> call(CreatePaymentParams params) async {
    return await paymentRepository.createPayment(
      bookingId: params.bookingId,
      userId: params.userId,
      amount: params.amount,
      method: params.method,
    );
  }
}

class CreatePaymentParams {
  final String bookingId;
  final String userId;
  final double amount;
  final PaymentMethod method;

  CreatePaymentParams({
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.method,
  });
}
