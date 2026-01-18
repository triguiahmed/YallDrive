import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/customer_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/owner_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/usecases/check_car_booked.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/usecases/edit_user_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/usecases/get_customer_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/usecases/get_owner_data.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditUserData _editUserData;
  final GetCustomerData _customerData;
  final GetOwnerData _ownerData;
  final CheckCarBooked _carBooked;
  ProfileBloc({
    required EditUserData editUserData,
    required GetCustomerData customerData,
    required GetOwnerData ownerData,
    required CheckCarBooked carBooked,
  })  : _editUserData = editUserData,
        _customerData = customerData,
        _ownerData = ownerData,
        _carBooked = carBooked,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<ProfileGetCustomerData>(_getCustomerData);
    on<ProfileGetOwnerData>(_getOwnerData);
    on<ProfileUpdateUser>(_updateUserDetails);
    on<ProfileGetOwnerCars>(_getOwnerCars);
    on<ProfileCheckIsBooked>(_checkIsBooked);
  }

  void _updateUserDetails(
    ProfileUpdateUser event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _editUserData(
      EditUserDataParams(
        name: event.name,
        profileImage: event.profileImage,
        userId: event.userId,
      ),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (user) => emit(ProfileUpdateSuccess()),
    );
  }

  void _getCustomerData(
    ProfileGetCustomerData event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _customerData(
      GetCustomerDataParams(
        userId: event.userId,
      ),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (data) => emit(ProfileCustomerDataSuccess(data)),
    );
  }

  void _getOwnerData(
    ProfileGetOwnerData event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _ownerData(
      GetOwnerDataParams(
        ownerId: event.ownerId,
      ),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (data) => emit(ProfileOwnerDataSuccess(data)),
    );
  }

  void _getOwnerCars(
    ProfileGetOwnerCars event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _ownerData(
      GetOwnerDataParams(ownerId: event.ownerId),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (data) => emit(ProfileOwnerCarsSuccess(
        data.cars,
      )),
    );
  }

  void _checkIsBooked(
    ProfileCheckIsBooked event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _carBooked(
      CheckCarBookedParams(
        carNo: event.carNo,
        isBooked: event.isBooked,
      ),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (data) => emit(ProfileUpdateSuccess()),
    );
  }
}
