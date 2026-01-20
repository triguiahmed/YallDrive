import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/review/data/datasources/review_remote_data_source.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource reviewRemoteDataSource;

  ReviewRepositoryImpl(this.reviewRemoteDataSource);

  @override
  Future<Either<Failure, Review>> createReview({
    required String carNo,
    required String userId,
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await reviewRemoteDataSource.createReview(
        carNo: carNo,
        userId: userId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Review>> getReviewById({
    required String reviewId,
  }) async {
    try {
      final review = await reviewRemoteDataSource.getReviewById(
        reviewId: reviewId,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getReviewsForCar({
    required String carNo,
  }) async {
    try {
      final reviews = await reviewRemoteDataSource.getReviewsForCar(
        carNo: carNo,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getReviewsByUser({
    required String userId,
  }) async {
    try {
      final reviews = await reviewRemoteDataSource.getReviewsByUser(
        userId: userId,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Review>> updateReview({
    required String reviewId,
    required String userId,
    int? rating,
    String? comment,
  }) async {
    try {
      final review = await reviewRemoteDataSource.updateReview(
        reviewId: reviewId,
        userId: userId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview({
    required String reviewId,
    required String userId,
  }) async {
    try {
      await reviewRemoteDataSource.deleteReview(
        reviewId: reviewId,
        userId: userId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getAverageRatingForCar({
    required String carNo,
  }) async {
    try {
      final averageRating = await reviewRemoteDataSource.getAverageRatingForCar(
        carNo: carNo,
      );
      return Right(averageRating);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserReviewedCar({
    required String carNo,
    required String userId,
  }) async {
    try {
      final hasReviewed = await reviewRemoteDataSource.hasUserReviewedCar(
        carNo: carNo,
        userId: userId,
      );
      return Right(hasReviewed);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
