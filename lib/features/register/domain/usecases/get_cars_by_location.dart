import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/core/common/entities/car_details.dart';
import 'package:yaladrive/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCarsByLocation
    implements Usecase<List<CarDetails>, GetCarsByLocationParams> {
  final RegisterRepository registerRepository;
  GetCarsByLocation(this.registerRepository);

  @override
  Future<Either<Failure, List<CarDetails>>> call(
      GetCarsByLocationParams params) async {
    return await registerRepository.getCarsByLocation(
      location: params.location,
    );
  }
}

class GetCarsByLocationParams {
  String location;
  GetCarsByLocationParams({
    required this.location,
  });
}
