import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class GetReviewsForCars implements UseCase<List<Review>, GetReviewsForCarsParams> {
  final ReviewRepository reviewRepository;

  GetReviewsForCars(this.reviewRepository);

  @override
  Future<Either<Failure, List<Review>>> call(GetReviewsForCarsParams params) async {
    return await reviewRepository.getReviewsForCars(
      carNos: params.carNos,
    );
  }
}

class GetReviewsForCarsParams {
  final List<String> carNos;

  GetReviewsForCarsParams({
    required this.carNos,
  });
}
