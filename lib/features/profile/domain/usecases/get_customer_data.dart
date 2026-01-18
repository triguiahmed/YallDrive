import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/customer_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/repositories/profile_repository.dart';
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
