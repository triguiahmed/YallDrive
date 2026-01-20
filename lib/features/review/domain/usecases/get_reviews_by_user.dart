import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class GetReviewsByUser implements Usecase<List<Review>, GetReviewsByUserParams> {
  final ReviewRepository reviewRepository;

  GetReviewsByUser(this.reviewRepository);

  @override
  Future<Either<Failure, List<Review>>> call(GetReviewsByUserParams params) async {
    return await reviewRepository.getReviewsByUser(
      userId: params.userId,
    );
  }
}

class GetReviewsByUserParams {
  final String userId;

  GetReviewsByUserParams({
    required this.userId,
  });
}
