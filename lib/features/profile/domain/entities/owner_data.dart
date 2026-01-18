import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';

class OwnerData {
  final String name;
  final String? profileUrl;
  final int noOfCars;
  final List<CarDetailsModel> cars;
  final String id;

  OwnerData({
    required this.name,
    required this.profileUrl,
    required this.noOfCars,
    required this.cars,
    required this.id,
  });
}
