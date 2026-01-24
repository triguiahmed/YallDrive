import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentsByUser implements Usecase<List<Payment>, GetPaymentsByUserParams> {
  final PaymentRepository paymentRepository;

  GetPaymentsByUser(this.paymentRepository);

  @override
  Future<Either<Failure, List<Payment>>> call(GetPaymentsByUserParams params) async {
    return await paymentRepository.getPaymentsByUser(
      userId: params.userId,
    );
  }
}

class GetPaymentsByUserParams {
  final String userId;

  GetPaymentsByUserParams({
    required this.userId,
  });
}
