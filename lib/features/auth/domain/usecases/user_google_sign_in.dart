import 'package:yaladrive/core/common/entities/user.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserGoogleSignIn implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  UserGoogleSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
