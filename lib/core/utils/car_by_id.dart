import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';

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
