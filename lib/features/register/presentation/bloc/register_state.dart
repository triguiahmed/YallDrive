part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}

final class RegisterSuccess extends RegisterState {
  final CarDetails carDetails;
  RegisterSuccess(this.carDetails);
}

final class RegisterGetListCarsSuccess extends RegisterState {
  final List<CarDetails> cars;
  RegisterGetListCarsSuccess(this.cars);
}

final class RegisterGetCarSuccess extends RegisterState {
  final CarDetails car;
  RegisterGetCarSuccess(this.car);
}
