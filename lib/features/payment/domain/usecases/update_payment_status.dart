import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class UpdatePaymentStatus implements Usecase<Payment, UpdatePaymentStatusParams> {
  final PaymentRepository paymentRepository;

  UpdatePaymentStatus(this.paymentRepository);

  @override
  Future<Either<Failure, Payment>> call(UpdatePaymentStatusParams params) async {
    return await paymentRepository.updatePaymentStatus(
      paymentId: params.paymentId,
      userId: params.userId,
      newStatus: params.newStatus,
    );
  }
}

class UpdatePaymentStatusParams {
  final String paymentId;
  final String userId;
  final PaymentStatus newStatus;

  UpdatePaymentStatusParams({
    required this.paymentId,
    required this.userId,
    required this.newStatus,
  });
}
