part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUpdateUser extends ProfileEvent {
  final String name;
  final File? profileImage;
  final String userId;

  ProfileUpdateUser({
    required this.name,
    required this.profileImage,
    required this.userId,
  });
}

class ProfileGetCustomerData extends ProfileEvent {
  final String userId;

  ProfileGetCustomerData({
    required this.userId,
  });
}

class ProfileGetOwnerData extends ProfileEvent {
  final String ownerId;

  ProfileGetOwnerData({
    required this.ownerId,
  });
}

class ProfileOwnerCarsSuccess extends ProfileState {
  final List<CarDetails> cars;
  ProfileOwnerCarsSuccess(this.cars);
}

class ProfileGetOwnerCars extends ProfileEvent {
  final String ownerId;

  ProfileGetOwnerCars({
    required this.ownerId,
  });
}

class ProfileCheckIsBooked extends ProfileEvent {
  final String carNo;
  final bool isBooked;

  ProfileCheckIsBooked({
    required this.carNo,
    required this.isBooked,
  });
}
