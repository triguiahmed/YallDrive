import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class UpdateReview implements Usecase<Review, UpdateReviewParams> {
  final ReviewRepository reviewRepository;

  UpdateReview(this.reviewRepository);

  @override
  Future<Either<Failure, Review>> call(UpdateReviewParams params) async {
    return await reviewRepository.updateReview(
      reviewId: params.reviewId,
      userId: params.userId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateReviewParams {
  final String reviewId;
  final String userId;
  final int? rating;
  final String? comment;

  UpdateReviewParams({
    required this.reviewId,
    required this.userId,
    this.rating,
    this.comment,
  });
}
