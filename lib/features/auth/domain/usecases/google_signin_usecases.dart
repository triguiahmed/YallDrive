import 'package:yalladrive/core/common/entities/user.dart';
import 'package:yalladrive/core/error/failure.dart';
import 'package:yalladrive/core/usecase/usecase.dart';
import 'package:yalladrive/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class GoogleSignIn implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  GoogleSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
