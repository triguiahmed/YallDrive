import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/features/payment/data/models/payment_model.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';

abstract interface class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentMethod method,
  });

  Future<PaymentModel> getPaymentById({
    required String paymentId,
  });

  Future<PaymentModel?> getPaymentForBooking({
    required String bookingId,
  });

  Future<List<PaymentModel>> getPaymentsByUser({
    required String userId,
  });

  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required String userId,
    required PaymentStatus newStatus,
  });

  Future<PaymentModel> updatePaymentMethod({
    required String paymentId,
    required String userId,
    required PaymentMethod newMethod,
  });

  Future<void> deletePayment({
    required String paymentId,
    required String userId,
  });

  Future<List<PaymentModel>> getPaymentsByStatus({
    required PaymentStatus status,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore fireStore;

  PaymentRemoteDataSourceImpl(this.fireStore);

  CollectionReference<Map<String, dynamic>> get _paymentsCollection =>
      fireStore.collection('payments');

  CollectionReference<Map<String, dynamic>> get _bookingsCollection =>
      fireStore.collection('bookings');

  @override
  Future<PaymentModel> createPayment({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentMethod method,
  }) async {
    try {
      // Check if booking exists
      final bookingSnapshot = await _bookingsCollection.doc(bookingId).get();

      if (!bookingSnapshot.exists) {
        throw ServerException('Booking not found');
      }

      final bookingData = bookingSnapshot.data()!;

      // Verify user owns the booking
      if (bookingData['userId'] != userId) {
        throw ServerException('You can only create payment for your own booking');
      }

      // Validate amount matches booking price
      final bookingPrice = (bookingData['price'] is int)
          ? (bookingData['price'] as int).toDouble()
          : (bookingData['price'] as double? ?? 0.0);

      if (amount != bookingPrice) {
        throw ServerException(
          'Payment amount ($amount) must match booking price ($bookingPrice)',
        );
      }

      // Check if payment already exists for this booking
      final existingPayment = await _paymentsCollection
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (existingPayment.docs.isNotEmpty) {
        throw ServerException('Payment already exists for this booking');
      }

      // Create new payment
      final paymentRef = _paymentsCollection.doc();
      final payment = PaymentModel(
        id: paymentRef.id,
        bookingId: bookingId,
        userId: userId,
        amount: amount,
        method: method,
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      await paymentRef.set(payment.toJson());
      return payment;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create payment: $e');
    }
  }

  @override
  Future<PaymentModel> getPaymentById({
    required String paymentId,
  }) async {
    try {
      final snapshot = await _paymentsCollection.doc(paymentId).get();

      if (!snapshot.exists) {
        throw ServerException('Payment not found');
      }

      return PaymentModel.fromJson(snapshot.data()!);
    } catch (e) {
      throw ServerException('Failed to get payment: $e');
    }
  }

  @override
  Future<PaymentModel?> getPaymentForBooking({
    required String bookingId,
  }) async {
    try {
      final snapshot = await _paymentsCollection
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return PaymentModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw ServerException('Failed to get payment for booking: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByUser({
    required String userId,
  }) async {
    try {
      final snapshot = await _paymentsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get payments by user: $e');
    }
  }

  @override
  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required String userId,
    required PaymentStatus newStatus,
  }) async {
    try {
      final paymentRef = _paymentsCollection.doc(paymentId);
      final snapshot = await paymentRef.get();

      if (!snapshot.exists) {
        throw ServerException('Payment not found');
      }

      final existingPayment = PaymentModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (existingPayment.userId != userId) {
        throw ServerException('You can only update your own payments');
      }

      // Validate status transition
      if (!existingPayment.status.canTransitionTo(newStatus)) {
        throw ServerException(
          'Invalid status transition from ${existingPayment.status.value} to ${newStatus.value}',
        );
      }

      final updateData = <String, dynamic>{
        'status': newStatus.value,
      };

      // Set paidAt timestamp when status changes to paid
      if (newStatus == PaymentStatus.paid) {
        updateData['paidAt'] = DateTime.now().millisecondsSinceEpoch;

        // Also update booking payment status
        await _bookingsCollection.doc(existingPayment.bookingId).update({
          'paymentStatus': 'Paid',
        });
      }

      await paymentRef.update(updateData);

      final updatedSnapshot = await paymentRef.get();
      return PaymentModel.fromJson(updatedSnapshot.data()!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update payment status: $e');
    }
  }

  @override
  Future<PaymentModel> updatePaymentMethod({
    required String paymentId,
    required String userId,
    required PaymentMethod newMethod,
  }) async {
    try {
      final paymentRef = _paymentsCollection.doc(paymentId);
      final snapshot = await paymentRef.get();

      if (!snapshot.exists) {
        throw ServerException('Payment not found');
      }

      final existingPayment = PaymentModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (existingPayment.userId != userId) {
        throw ServerException('You can only update your own payments');
      }

      // Can only change method if payment is pending
      if (existingPayment.status != PaymentStatus.pending) {
        throw ServerException('Can only change payment method for pending payments');
      }

      await paymentRef.update({
        'method': newMethod.value,
      });

      final updatedSnapshot = await paymentRef.get();
      return PaymentModel.fromJson(updatedSnapshot.data()!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update payment method: $e');
    }
  }

  @override
  Future<void> deletePayment({
    required String paymentId,
    required String userId,
  }) async {
    try {
      final paymentRef = _paymentsCollection.doc(paymentId);
      final snapshot = await paymentRef.get();

      if (!snapshot.exists) {
        throw ServerException('Payment not found');
      }

      final existingPayment = PaymentModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (existingPayment.userId != userId) {
        throw ServerException('You can only delete your own payments');
      }

      // Can only delete pending payments
      if (existingPayment.status != PaymentStatus.pending) {
        throw ServerException('Can only delete pending payments');
      }

      await paymentRef.delete();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete payment: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByStatus({
    required PaymentStatus status,
  }) async {
    try {
      final snapshot = await _paymentsCollection
          .where('status', isEqualTo: status.value)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get payments by status: $e');
    }
  }
}
