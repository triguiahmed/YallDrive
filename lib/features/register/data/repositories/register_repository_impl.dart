import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/features/register/data/datasources/register_remote_data_source.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/repositories/register_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;
  RegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CarDetailsModel>> registerCarDetails({
    required String location,
    required String carName,
    required String carNumber,
    required double pricePerDay,
    required File carImage,
    required String ownerId,
  }) async {
    try {
      final carDetailsModel = await remoteDataSource.registerCarDetails(
        location: location,
        carName: carName,
        carNumber: carNumber,
        pricePerDay: pricePerDay,
        carImage: carImage,
        ownerId: ownerId,
      );

      return Right(carDetailsModel);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CarDetails>>> getCarsByLocation({
    required String location,
  }) async {
    try {
      final cars = await remoteDataSource.getCarsByLocation(
        location: location,
      );

      return Right(cars);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, CarDetails>> getCarById({
    required String carNo,
  }) async {
    try {
      final car = await remoteDataSource.getCarById(
        carNo: carNo,
      );

      return Right(car);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CarDetailsModel>>> getAllCars() async {
    try {
      final cars = await remoteDataSource.getAllCars();

      return Right(cars);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
