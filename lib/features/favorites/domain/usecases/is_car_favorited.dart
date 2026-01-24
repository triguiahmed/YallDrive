import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class IsCarFavorited implements Usecase<bool, IsCarFavoritedParams> {
  final FavoritesRepository favoritesRepository;

  IsCarFavorited(this.favoritesRepository);

  @override
  Future<Either<Failure, bool>> call(IsCarFavoritedParams params) async {
    return await favoritesRepository.isCarFavorited(
      userId: params.userId,
      carNo: params.carNo,
    );
  }
}

class IsCarFavoritedParams {
  final String userId;
  final String carNo;

  IsCarFavoritedParams({
    required this.userId,
    required this.carNo,
  });
}
