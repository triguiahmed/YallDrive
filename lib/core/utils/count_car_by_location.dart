import 'package:yaladrive/core/common/entities/car_details.dart';

Map<String, int> countCarByLocation(List<CarDetails> cars) {
  final Map<String, int> carCounts = {};
  for (var car in cars) {
    carCounts[car.location] = (carCounts[car.location] ?? 0) + 1;
  }
  return carCounts;
}
