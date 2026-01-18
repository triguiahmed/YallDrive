import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllCars implements Usecase<List<CarDetails>, NoParams> {
  final RegisterRepository registerRepository;
  GetAllCars(this.registerRepository);

  @override
  Future<Either<Failure, List<CarDetails>>> call(NoParams params) async {
    return await registerRepository.getAllCars();
  }
}
