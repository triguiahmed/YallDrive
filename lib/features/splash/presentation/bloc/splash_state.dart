part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isLoggedIn;
  SplashLoaded(this.isLoggedIn);
}

class SplashFailure extends SplashState {
  final String message;
  SplashFailure(this.message);
}
