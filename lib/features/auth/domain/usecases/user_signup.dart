import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/core/common/entities/user.dart';
import 'package:yalladrive/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignup(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
