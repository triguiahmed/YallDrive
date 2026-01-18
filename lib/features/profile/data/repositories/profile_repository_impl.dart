import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/datasources/profile_remote_data_sources.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/customer_data_model.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/owner_data_model.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSources profileRemoteDataSources;

  ProfileRepositoryImpl(
    this.profileRemoteDataSources,
  );

  @override
  Future<Either<Failure, CustomerDataModel>> getCustomerData({
    required String userId,
  }) async {
    try {
      final customerDataModel = await profileRemoteDataSources.getCustomerData(
        userId: userId,
      );
      return Right(customerDataModel);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> editUserData({
    required String name,
    required File? profileImage,
    required String userId,
  }) async {
    try {
      await profileRemoteDataSources.editUserData(
        name: name,
        profileImage: profileImage,
        userId: userId,
      );

      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, OwnerDataModel>> getOwnerData({
    required String ownerId,
  }) async {
    try {
      final ownerDataModel = await profileRemoteDataSources.getOwnerData(
        ownerId: ownerId,
      );

      return Right(ownerDataModel);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> checkCarBooked({
    required String carNo,
    required bool isBooked,
  }) async {
    try {
      await profileRemoteDataSources.checkCarBooked(
        carNo: carNo,
        isBooked: isBooked,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
