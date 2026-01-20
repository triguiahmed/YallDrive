import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class DeletePayment implements Usecase<void, DeletePaymentParams> {
  final PaymentRepository paymentRepository;

  DeletePayment(this.paymentRepository);

  @override
  Future<Either<Failure, void>> call(DeletePaymentParams params) async {
    return await paymentRepository.deletePayment(
      paymentId: params.paymentId,
      userId: params.userId,
    );
  }
}

class DeletePaymentParams {
  final String paymentId;
  final String userId;

  DeletePaymentParams({
    required this.paymentId,
    required this.userId,
  });
}
