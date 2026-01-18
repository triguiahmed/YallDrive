import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class GetInitialData implements Usecase<bool, NoParams> {
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      return Right(true);
    } catch (e) {
      return Left(
        Failure('Failed to fetch initial data'),
      );
    }
  }
}
