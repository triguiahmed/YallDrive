import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/profile/domain/entities/customer_data.dart';
import 'package:yaladrive/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';


class GetCustomerData implements Usecase<CustomerData, GetCustomerDataParams> {
  final ProfileRepository profileRepository;
  GetCustomerData(this.profileRepository);

  @override
  Future<Either<Failure, CustomerData>> call(
      GetCustomerDataParams params) {
    return profileRepository.getCustomerData(
      userId: params.userId, 
    );
  }
}

class GetCustomerDataParams {
  final String userId;

  GetCustomerDataParams({
    required this.userId,
  });
}
