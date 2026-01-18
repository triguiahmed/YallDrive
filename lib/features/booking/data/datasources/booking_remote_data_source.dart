import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/booking/data/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BookingRemoteDataSource {
  Future<void> bookingCar({
    required String userId,
    required String carNo,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String ownerId,
  });

  Future<List<BookingModel>> showBookingForOwner({
    required String ownerId,
  });

  Future<List<BookingModel>> showBookingForCar({
    required String carNo,
  });

  Future<List<BookingModel>> showBookingForUser({
    required String userId,
  });

  Future<void> ownerRequestApprove({
    required String ownerId,
    required bool isApproved,
    required String bookingId,
  });

  Future<void> paymentApprove({
    required String paymentStatus,
    required String bookingId,
  });
}

class BookingRemoteDataSourceImpl extends BookingRemoteDataSource {
  final FirebaseFirestore fireStore;

  BookingRemoteDataSourceImpl(
    this.fireStore,
  );

  @override
  Future<void> bookingCar({
    required String userId,
    required String carNo,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String ownerId,
  }) async {
    try {
      final bookingRef = fireStore.collection('bookings').doc();
      final existingBookings = await fireStore
          .collection('bookings')
          .where('carNo', isEqualTo: carNo)
          .get();

      bool hasConflict = existingBookings.docs.any((doc) {
        final data = doc.data();
        DateTime existingStart =
            DateTime.fromMillisecondsSinceEpoch(data['startDate']);
        DateTime existingEnd =
            DateTime.fromMillisecondsSinceEpoch(data['endDate']);

        return !(endDate.isBefore(existingStart) ||
            startDate.isAfter(existingEnd));
      });

      if (hasConflict) {
        throw ServerException("The car is already booked for this period.");
      }

      final booking = BookingModel(
        id: bookingRef.id,
        userId: userId,
        carNo: carNo,
        startDate: startDate,
        endDate: endDate,
        price: price,
        status: "Pending",
        isApproved: false,
        ownerId: ownerId,
        paymentStatus: 'Pending',
      );

      await bookingRef.set(booking.toJson());
    } on ServerException catch (e) {
      throw ServerException('Booking error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<BookingModel>> showBookingForCar({
    required String carNo,
  }) async {
    try {
      final querySnapshot = await fireStore
          .collection('bookings')
          .where('carNo', isEqualTo: carNo)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> showBookingForOwner({
    required String ownerId,
  }) async {
    try {
      final querySnapshot = await fireStore
          .collection('bookings')
          .where('ownerId', isEqualTo: ownerId)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> showBookingForUser({
    required String userId,
  }) async {
    try {
      final querySnapshot = await fireStore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> ownerRequestApprove({
    required String ownerId,
    required bool isApproved,
    required String bookingId,
  }) async {
    try {
      final bookingRef = fireStore.collection('bookings').doc(bookingId);

      final docSnapshot = await bookingRef.get();

      if (!docSnapshot.exists) {
        throw ServerException("Booking with ID $bookingId not found.");
      }

      await bookingRef.update({
        'isApproved': isApproved,
        'status': isApproved ? 'Confirmed' : 'Denied',
      });
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> paymentApprove({
    required String paymentStatus,
    required String bookingId,
  }) async {
    try {
      final bookingRef = fireStore.collection('bookings').doc(bookingId);

      final docSnapshot = await bookingRef.get();

      if (!docSnapshot.exists) {
        throw ServerException("Booking with ID $bookingId not found.");
      }

      await bookingRef.update({
        'paymentStatus': paymentStatus,
      });
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
