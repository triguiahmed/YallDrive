import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class DeleteReview implements Usecase<void, DeleteReviewParams> {
  final ReviewRepository reviewRepository;

  DeleteReview(this.reviewRepository);

  @override
  Future<Either<Failure, void>> call(DeleteReviewParams params) async {
    return await reviewRepository.deleteReview(
      reviewId: params.reviewId,
      userId: params.userId,
    );
  }
}

class DeleteReviewParams {
  final String reviewId;
  final String userId;

  DeleteReviewParams({
    required this.reviewId,
    required this.userId,
  });
}
