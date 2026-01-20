import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';

abstract interface class PaymentRepository {
  /// Create a new payment for a booking
  /// Validates that booking exists and has no existing payment
  /// Validates that amount matches booking price
  Future<Either<Failure, Payment>> createPayment({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentMethod method,
  });

  /// Get a payment by its ID
  Future<Either<Failure, Payment>> getPaymentById({
    required String paymentId,
  });

  /// Get payment for a specific booking
  Future<Either<Failure, Payment?>> getPaymentForBooking({
    required String bookingId,
  });

  /// Get all payments for a specific user
  Future<Either<Failure, List<Payment>>> getPaymentsByUser({
    required String userId,
  });

  /// Update payment status with validation
  Future<Either<Failure, Payment>> updatePaymentStatus({
    required String paymentId,
    required String userId,
    required PaymentStatus newStatus,
  });

  /// Update payment method
  Future<Either<Failure, Payment>> updatePaymentMethod({
    required String paymentId,
    required String userId,
    required PaymentMethod newMethod,
  });

  /// Delete a payment (only if pending)
  Future<Either<Failure, void>> deletePayment({
    required String paymentId,
    required String userId,
  });

  /// Get payments by status
  Future<Either<Failure, List<Payment>>> getPaymentsByStatus({
    required PaymentStatus status,
  });
}
