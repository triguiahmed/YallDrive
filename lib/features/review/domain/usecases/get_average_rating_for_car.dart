import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/review/domain/repositories/review_repository.dart';

class GetAverageRatingForCar implements Usecase<double, GetAverageRatingParams> {
  final ReviewRepository reviewRepository;

  GetAverageRatingForCar(this.reviewRepository);

  @override
  Future<Either<Failure, double>> call(GetAverageRatingParams params) async {
    return await reviewRepository.getAverageRatingForCar(
      carNo: params.carNo,
    );
  }
}

class GetAverageRatingParams {
  final String carNo;

  GetAverageRatingParams({
    required this.carNo,
  });
}
