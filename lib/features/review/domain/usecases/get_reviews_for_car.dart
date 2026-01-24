import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class GetReviewsForCar implements Usecase<List<Review>, GetReviewsForCarParams> {
  final ReviewRepository reviewRepository;

  GetReviewsForCar(this.reviewRepository);

  @override
  Future<Either<Failure, List<Review>>> call(GetReviewsForCarParams params) async {
    return await reviewRepository.getReviewsForCar(
      carNo: params.carNo,
    );
  }
}

class GetReviewsForCarParams {
  final String carNo;

  GetReviewsForCarParams({
    required this.carNo,
  });
}
