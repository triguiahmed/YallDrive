import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/usecases/get_all_cars.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/usecases/get_car_by_id.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/usecases/get_cars_by_location.dart';
import 'package:car_rental_app_clean_arch/features/register/domain/usecases/register_car_details.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterCarDetails _registerCarDetails;
  final GetCarsByLocation _getCarsByLocation;
  final GetCarById _getCarById;
  final GetAllCars _getAllCars;

  RegisterBloc({
    required RegisterCarDetails registerCarDetails,
    required GetCarsByLocation getCarsByLocation,
    required GetCarById getCarById,
    required GetAllCars getAllCars,
  })  : _registerCarDetails = registerCarDetails,
        _getCarsByLocation = getCarsByLocation,
        _getCarById = getCarById,
        _getAllCars = getAllCars,
        super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) => emit(RegisterLoading()));
    on<RegisterCar>(_onRegisterCar);
    on<RegisterGetCarByLocation>(_onGetCarsByLocation);
    on<RegisterGetCarById>(_onGetCarsById);
    on<RegisterGetAllCars>(_onGetAllCars);
  }

  void _onRegisterCar(
    RegisterCar event,
    Emitter<RegisterState> emit,
  ) async {
    final res = await _registerCarDetails(
      CarDetailsParams(
        location: event.location,
        carName: event.carName,
        carNumber: event.carNumber,
        pricePerDay: event.pricePerDay,
        carImage: event.carImage,
        ownerId: event.ownerId,
      ),
    );

    res.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (carDetails) => emit(RegisterSuccess(carDetails)),
    );
  }

  void _onGetCarsByLocation(
    RegisterGetCarByLocation event,
    Emitter<RegisterState> emit,
  ) async {
    final res = await _getCarsByLocation(
      GetCarsByLocationParams(location: event.location),
    );

    res.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (cars) => emit(RegisterGetListCarsSuccess(cars)),
    );
  }

  void _onGetCarsById(
    RegisterGetCarById event,
    Emitter<RegisterState> emit,
  ) async {
    final res = await _getCarById(
      GetCarByIdParams(carNo: event.carNo),
    );

    res.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (car) => emit(RegisterGetCarSuccess(car)),
    );
  }

  void _onGetAllCars(
    RegisterGetAllCars event,
    Emitter<RegisterState> emit,
  ) async {
    final res = await _getAllCars(NoParams());

    res.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (cars) => emit(RegisterGetListCarsSuccess(cars)),
    );
  }
}
