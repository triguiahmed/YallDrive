import 'dart:io';
import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class RegisterRemoteDataSource {
  Future<CarDetailsModel> registerCarDetails({
    required String location,
    required String carName,
    required String carNumber,
    required double pricePerDay,
    required File carImage,
    required String ownerId,
  });

  Future<List<CarDetailsModel>> getCarsByLocation({
    required String location,
  });

  Future<CarDetailsModel> getCarById({
    required String carNo,
  });

  Future<List<CarDetailsModel>> getAllCars();
}

class RegistorRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseStorage fireStorage;

  RegistorRemoteDataSourceImpl(
    this.fireStore,
    this.fireStorage,
  );

  @override
  Future<CarDetailsModel> registerCarDetails({
    required String location,
    required String carName,
    required String carNumber,
    required double pricePerDay,
    required File carImage,
    required String ownerId,
  }) async {
    try {
      final ref = fireStorage.ref().child('car_images/$carNumber.jpg');
      final uploadTask = await ref.putFile(carImage);
      final carImageUrl = await uploadTask.ref.getDownloadURL();

      final carDetails = CarDetailsModel(
        location: location,
        carName: carName,
        carNumber: carNumber,
        pricePerDay: pricePerDay,
        carUrl: carImageUrl,
        ownerId: ownerId,
        isBooked: false,
      );

      await fireStore
          .collection('cars')
          .doc(carNumber)
          .set(carDetails.toJson());

      return carDetails;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CarDetailsModel>> getCarsByLocation({
    required String location,
  }) async {
    try {
      final carsSnapshot = await fireStore
          .collection('cars')
          .where('location', isEqualTo: location)
          .get();

      final List<CarDetailsModel> cars = carsSnapshot.docs
          .map((doc) => CarDetailsModel.fromJson(doc.data()))
          .toList();

      return cars;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CarDetailsModel> getCarById({
    required String carNo,
  }) async {
    try {
      final carsSnapshot = await fireStore
          .collection('cars')
          .where('carNumber', isEqualTo: carNo)
          .get();

      if (carsSnapshot.docs.isEmpty) {
        throw ServerException("Car not found");
      }

      final carData = carsSnapshot.docs.first.data();
      return CarDetailsModel.fromJson(carData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<CarDetailsModel> fetchCarById(String carNo) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      final carsSnapshot = await fireStore
          .collection('cars')
          .where('carNumber', isEqualTo: carNo)
          .get();

      if (carsSnapshot.docs.isEmpty) {
        throw ServerException("Car not found");
      }

      final carData = carsSnapshot.docs.first.data();
      return CarDetailsModel.fromJson(carData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CarDetailsModel>> getAllCars() async {
    try {
      final carsSnapshot = await fireStore.collection('cars').get();

      final List<CarDetailsModel> cars = carsSnapshot.docs
          .map((doc) => CarDetailsModel.fromJson(doc.data()))
          .toList();

      return cars;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
