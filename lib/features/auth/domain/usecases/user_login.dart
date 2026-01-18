import 'package:car_rental_app_clean_arch/core/common/entities/user.dart';
import 'package:car_rental_app_clean_arch/core/error/failure.dart';
import 'package:car_rental_app_clean_arch/core/usecase/usecase.dart';
import 'package:car_rental_app_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
