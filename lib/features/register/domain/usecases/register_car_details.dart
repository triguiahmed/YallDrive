import 'dart:io';

import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/core/common/entities/car_details.dart';
import 'package:yalladrive/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterCarDetails implements Usecase<CarDetails, CarDetailsParams> {
  final RegisterRepository registerRepository;
  RegisterCarDetails(this.registerRepository);

  @override
  Future<Either<Failure, CarDetails>> call(CarDetailsParams params) async {
    return await registerRepository.registerCarDetails(
      location: params.location,
      carName: params.carName,
      carNumber: params.carNumber,
      pricePerDay: params.pricePerDay,
      carImage: params.carImage,
      ownerId: params.ownerId,
    );
  }
}

class CarDetailsParams {
  final String location;
  final String carName;
  final String carNumber;
  final double pricePerDay;
  final File carImage;
  final String ownerId;

  CarDetailsParams({
    required this.location,
    required this.carName,
    required this.carNumber,
    required this.pricePerDay,
    required this.carImage,
    required this.ownerId,
  });
}
