import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/profile/domain/entities/owner_data.dart';
import 'package:yaladrive/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetOwnerData implements Usecase<OwnerData, GetOwnerDataParams> {
  final ProfileRepository profileRepository;
  GetOwnerData(this.profileRepository);

  @override
  Future<Either<Failure, OwnerData>> call(GetOwnerDataParams params) async {
    return await profileRepository.getOwnerData(
      ownerId: params.ownerId,
    );
  }
}

class GetOwnerDataParams {
  final String ownerId;

  GetOwnerDataParams({
    required this.ownerId,
  });
}
