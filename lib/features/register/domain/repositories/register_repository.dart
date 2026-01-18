import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RegisterRepository {
  Future<Either<Failure, CarDetails>> registerCarDetails({
    required String location,
    required String carName,
    required String carNumber,
    required double pricePerDay,
    required File carImage,
    required String ownerId,
  });

  Future<Either<Failure, List<CarDetails>>> getCarsByLocation({
    required String location,
  });

  Future<Either<Failure, CarDetails>> getCarById({
    required String carNo,
  });

  Future<Either<Failure, List<CarDetails>>> getAllCars();
}
