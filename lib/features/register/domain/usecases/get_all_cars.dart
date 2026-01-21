import 'package:yalladrive/core/common/entities/car_details.dart';
import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllCars implements Usecase<List<CarDetails>, NoParams> {
  final RegisterRepository registerRepository;
  GetAllCars(this.registerRepository);

  @override
  Future<Either<Failure, List<CarDetails>>> call(NoParams params) async {
    return await registerRepository.getAllCars();
  }
}
