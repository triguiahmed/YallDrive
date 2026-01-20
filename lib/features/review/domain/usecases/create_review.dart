import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class CreateReview implements Usecase<Review, CreateReviewParams> {
  final ReviewRepository reviewRepository;

  CreateReview(this.reviewRepository);

  @override
  Future<Either<Failure, Review>> call(CreateReviewParams params) async {
    return await reviewRepository.createReview(
      carNo: params.carNo,
      userId: params.userId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class CreateReviewParams {
  final String carNo;
  final String userId;
  final int rating;
  final String comment;

  CreateReviewParams({
    required this.carNo,
    required this.userId,
    required this.rating,
    required this.comment,
  });
}
