import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class AddFavorite implements Usecase<Favorite, AddFavoriteParams> {
  final FavoritesRepository favoritesRepository;

  AddFavorite(this.favoritesRepository);

  @override
  Future<Either<Failure, Favorite>> call(AddFavoriteParams params) async {
    return await favoritesRepository.addFavorite(
      userId: params.userId,
      carNo: params.carNo,
    );
  }
}

class AddFavoriteParams {
  final String userId;
  final String carNo;

  AddFavoriteParams({
    required this.userId,
    required this.carNo,
  });
}
