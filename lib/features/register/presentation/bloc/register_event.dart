part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterCar extends RegisterEvent {
  final String location;
  final String carName;
  final String carNumber;
  final double pricePerDay;
  final File carImage;
  final String ownerId;

  RegisterCar({
    required this.location,
    required this.carName,
    required this.carNumber,
    required this.pricePerDay,
    required this.carImage,
    required this.ownerId,
  });
}

class RegisterGetCarByLocation extends RegisterEvent {
  final String location;

  RegisterGetCarByLocation({
    required this.location,
  });
}

class RegisterGetCarById extends RegisterEvent {
  final String carNo;

  RegisterGetCarById({
    required this.carNo,
  });
}

class RegisterGetAllCars extends RegisterEvent{}
