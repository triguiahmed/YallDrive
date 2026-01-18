import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/customer_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/owner_data.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, CustomerData>> getCustomerData({
    required String userId,
  });

  Future<Either<Failure, OwnerData>> getOwnerData({
    required String ownerId,
  });

  Future<Either<Failure, void>> editUserData({
    required String name,
    required File? profileImage,
    required String userId,
  });

  Future<Either<Failure, void>> checkCarBooked({
    required String carNo,
    required bool isBooked,
  });
}
