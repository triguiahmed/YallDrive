import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditUserData implements Usecase<void, EditUserDataParams> {
  final ProfileRepository profileRepository;
  EditUserData(this.profileRepository);

  @override
  Future<Either<Failure, void>> call(EditUserDataParams params) async {
    return await profileRepository.editUserData(
      name: params.name,
      profileImage: params.profileImage,
      userId: params.userId,
    );
  }
}

class EditUserDataParams {
  final String name;
  final File? profileImage;
  final String userId;

  EditUserDataParams({
    required this.name,
    required this.profileImage,
    required this.userId,
  });
}
