import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavorite implements Usecase<void, RemoveFavoriteParams> {
  final FavoritesRepository favoritesRepository;

  RemoveFavorite(this.favoritesRepository);

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return await favoritesRepository.removeFavorite(
      favoriteId: params.favoriteId,
      userId: params.userId,
    );
  }
}

class RemoveFavoriteParams {
  final String favoriteId;
  final String userId;

  RemoveFavoriteParams({
    required this.favoriteId,
    required this.userId,
  });
}
