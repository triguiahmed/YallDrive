import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoritesByUser implements Usecase<List<Favorite>, GetFavoritesByUserParams> {
  final FavoritesRepository favoritesRepository;

  GetFavoritesByUser(this.favoritesRepository);

  @override
  Future<Either<Failure, List<Favorite>>> call(GetFavoritesByUserParams params) async {
    return await favoritesRepository.getFavoritesByUser(
      userId: params.userId,
    );
  }
}

class GetFavoritesByUserParams {
  final String userId;

  GetFavoritesByUserParams({
    required this.userId,
  });
}
