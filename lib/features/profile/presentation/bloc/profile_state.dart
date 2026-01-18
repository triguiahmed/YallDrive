part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileCustomerDataSuccess extends ProfileState {
  final CustomerData customerData;
  ProfileCustomerDataSuccess(this.customerData);
}

final class ProfileOwnerDataSuccess extends ProfileState {
  final OwnerData ownerData;
  ProfileOwnerDataSuccess(this.ownerData);
}

final class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}
