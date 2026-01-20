import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckCarBooked implements Usecase<void, CheckCarBookedParams> {
  final ProfileRepository profileRepository;
  CheckCarBooked(this.profileRepository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await profileRepository.checkCarBooked(
      carNo: params.carNo,
      isBooked: params.isBooked,
    );
  }
}

class CheckCarBookedParams {
  final String carNo;
  final bool isBooked;

  CheckCarBookedParams({
    required this.carNo,
    required this.isBooked,
  });
}
