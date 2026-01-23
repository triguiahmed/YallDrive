import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource paymentRemoteDataSource;

  PaymentRepositoryImpl(this.paymentRemoteDataSource);

  @override
  Future<Either<Failure, Payment>> createPayment({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentMethod method,
    PaymentStatus status = PaymentStatus.pending,
  }) async {
    try {
      final payment = await paymentRemoteDataSource.createPayment(
        bookingId: bookingId,
        userId: userId,
        amount: amount,
        method: method,
        status: status,
      );
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPaymentById({
    required String paymentId,
  }) async {
    try {
      final payment = await paymentRemoteDataSource.getPaymentById(
        paymentId: paymentId,
      );
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Payment?>> getPaymentForBooking({
    required String bookingId,
  }) async {
    try {
      final payment = await paymentRemoteDataSource.getPaymentForBooking(
        bookingId: bookingId,
      );
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByUser({
    required String userId,
  }) async {
    try {
      final payments = await paymentRemoteDataSource.getPaymentsByUser(
        userId: userId,
      );
      return Right(payments);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePaymentStatus({
    required String paymentId,
    required String userId,
    required PaymentStatus newStatus,
  }) async {
    try {
      final payment = await paymentRemoteDataSource.updatePaymentStatus(
        paymentId: paymentId,
        userId: userId,
        newStatus: newStatus,
      );
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePaymentMethod({
    required String paymentId,
    required String userId,
    required PaymentMethod newMethod,
  }) async {
    try {
      final payment = await paymentRemoteDataSource.updatePaymentMethod(
        paymentId: paymentId,
        userId: userId,
        newMethod: newMethod,
      );
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment({
    required String paymentId,
    required String userId,
  }) async {
    try {
      await paymentRemoteDataSource.deletePayment(
        paymentId: paymentId,
        userId: userId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByStatus({
    required PaymentStatus status,
  }) async {
    try {
      final payments = await paymentRemoteDataSource.getPaymentsByStatus(
        status: status,
      );
      return Right(payments);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
