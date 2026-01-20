import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/features/review/data/models/review_model.dart';

abstract interface class ReviewRemoteDataSource {
  Future<ReviewModel> createReview({
    required String carNo,
    required String userId,
    required int rating,
    required String comment,
  });

  Future<ReviewModel> getReviewById({
    required String reviewId,
  });

  Future<List<ReviewModel>> getReviewsForCar({
    required String carNo,
  });

  Future<List<ReviewModel>> getReviewsByUser({
    required String userId,
  });

  Future<ReviewModel> updateReview({
    required String reviewId,
    required String userId,
    int? rating,
    String? comment,
  });

  Future<void> deleteReview({
    required String reviewId,
    required String userId,
  });

  Future<double> getAverageRatingForCar({
    required String carNo,
  });

  Future<bool> hasUserReviewedCar({
    required String carNo,
    required String userId,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore fireStore;

  ReviewRemoteDataSourceImpl(this.fireStore);

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      fireStore.collection('reviews');

  @override
  Future<ReviewModel> createReview({
    required String carNo,
    required String userId,
    required int rating,
    required String comment,
  }) async {
    try {
      // Validate rating range (1-5)
      if (rating < 1 || rating > 5) {
        throw ServerException('Rating must be between 1 and 5');
      }

      // Check if car exists
      final carSnapshot = await fireStore
          .collection('cars')
          .where('carNumber', isEqualTo: carNo)
          .get();

      if (carSnapshot.docs.isEmpty) {
        throw ServerException('Car not found');
      }

      // Check if user exists
      final userSnapshot =
          await fireStore.collection('users').doc(userId).get();

      if (!userSnapshot.exists) {
        throw ServerException('User not found');
      }

      // Check if user has already reviewed this car
      final existingReview = await _reviewsCollection
          .where('carNo', isEqualTo: carNo)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingReview.docs.isNotEmpty) {
        throw ServerException('You have already reviewed this car');
      }

      // Create new review
      final reviewRef = _reviewsCollection.doc();
      final review = ReviewModel(
        id: reviewRef.id,
        carNo: carNo,
        userId: userId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await reviewRef.set(review.toJson());
      return review;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create review: $e');
    }
  }

  @override
  Future<ReviewModel> getReviewById({
    required String reviewId,
  }) async {
    try {
      final snapshot = await _reviewsCollection.doc(reviewId).get();

      if (!snapshot.exists) {
        throw ServerException('Review not found');
      }

      return ReviewModel.fromJson(snapshot.data()!);
    } catch (e) {
      throw ServerException('Failed to get review: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsForCar({
    required String carNo,
  }) async {
    try {
      final snapshot = await _reviewsCollection
          .where('carNo', isEqualTo: carNo)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get reviews for car: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsByUser({
    required String userId,
  }) async {
    try {
      final snapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get reviews by user: $e');
    }
  }

  @override
  Future<ReviewModel> updateReview({
    required String reviewId,
    required String userId,
    int? rating,
    String? comment,
  }) async {
    try {
      final reviewRef = _reviewsCollection.doc(reviewId);
      final snapshot = await reviewRef.get();

      if (!snapshot.exists) {
        throw ServerException('Review not found');
      }

      final existingReview = ReviewModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (existingReview.userId != userId) {
        throw ServerException('You can only update your own reviews');
      }

      // Validate rating if provided
      if (rating != null && (rating < 1 || rating > 5)) {
        throw ServerException('Rating must be between 1 and 5');
      }

      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (comment != null) updateData['comment'] = comment;

      if (updateData.isNotEmpty) {
        await reviewRef.update(updateData);
      }

      final updatedSnapshot = await reviewRef.get();
      return ReviewModel.fromJson(updatedSnapshot.data()!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update review: $e');
    }
  }

  @override
  Future<void> deleteReview({
    required String reviewId,
    required String userId,
  }) async {
    try {
      final reviewRef = _reviewsCollection.doc(reviewId);
      final snapshot = await reviewRef.get();

      if (!snapshot.exists) {
        throw ServerException('Review not found');
      }

      final existingReview = ReviewModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (existingReview.userId != userId) {
        throw ServerException('You can only delete your own reviews');
      }

      await reviewRef.delete();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete review: $e');
    }
  }

  @override
  Future<double> getAverageRatingForCar({
    required String carNo,
  }) async {
    try {
      final snapshot =
          await _reviewsCollection.where('carNo', isEqualTo: carNo).get();

      if (snapshot.docs.isEmpty) {
        return 0.0;
      }

      final totalRating = snapshot.docs.fold<int>(
        0,
        (sum, doc) => sum + (doc.data()['rating'] as int? ?? 0),
      );

      return totalRating / snapshot.docs.length;
    } catch (e) {
      throw ServerException('Failed to get average rating: $e');
    }
  }

  @override
  Future<bool> hasUserReviewedCar({
    required String carNo,
    required String userId,
  }) async {
    try {
      final snapshot = await _reviewsCollection
          .where('carNo', isEqualTo: carNo)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw ServerException('Failed to check review status: $e');
    }
  }
}
