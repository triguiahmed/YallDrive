import 'package:bloc/bloc.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/splash/domain/usecases/usecases.dart';
import 'package:flutter/material.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetInitialData getInitialData;
  SplashBloc(this.getInitialData) : super(SplashInitial()) {
    on<LoadSplashEvent>((event, emit) async {
      final res = await getInitialData(NoParams());
      res.fold(
        (failure) {
          emit(SplashFailure(failure.message));
        },
        (loggedIn) {
          emit(SplashLoaded(loggedIn));
        },
      );
    });
  }
}
