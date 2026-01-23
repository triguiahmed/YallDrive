import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';

abstract interface class ReviewRepository {
  /// Create a new review
  /// Validates that user hasn't already reviewed this car
  /// Validates rating is between 1-5
  Future<Either<Failure, Review>> createReview({
    required String carNo,
    required String userId,
    required int rating,
    required String comment,
  });

  /// Get a review by its ID
  Future<Either<Failure, Review>> getReviewById({
    required String reviewId,
  });

  /// Get all reviews for a specific car
  Future<Either<Failure, List<Review>>> getReviewsForCar({
    required String carNo,
  });

  /// Get all reviews for a list of cars
  Future<Either<Failure, List<Review>>> getReviewsForCars({
    required List<String> carNos,
  });

  /// Get all reviews by a specific user
  Future<Either<Failure, List<Review>>> getReviewsByUser({
    required String userId,
  });

  /// Update an existing review (only by the owner)
  Future<Either<Failure, Review>> updateReview({
    required String reviewId,
    required String userId,
    int? rating,
    String? comment,
  });

  /// Delete a review (only by the owner)
  Future<Either<Failure, void>> deleteReview({
    required String reviewId,
    required String userId,
  });

  /// Get average rating for a car
  Future<Either<Failure, double>> getAverageRatingForCar({
    required String carNo,
  });

  /// Check if user has already reviewed a car
  Future<Either<Failure, bool>> hasUserReviewedCar({
    required String carNo,
    required String userId,
  });
}
