import 'package:yalladrive/core/common/entities/car_details.dart';
import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCarById implements Usecase<CarDetails, GetCarByIdParams> {
  final RegisterRepository registerRepository;
  GetCarById(this.registerRepository);

  @override
  Future<Either<Failure, CarDetails>> call(params) async {
    return await registerRepository.getCarById(
      carNo: params.carNo,
    );
  }
}

class GetCarByIdParams {
  final String carNo;

  GetCarByIdParams({
    required this.carNo,
  });
}
