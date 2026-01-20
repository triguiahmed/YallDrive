import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class ToggleFavorite implements Usecase<bool, ToggleFavoriteParams> {
  final FavoritesRepository favoritesRepository;

  ToggleFavorite(this.favoritesRepository);

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    return await favoritesRepository.toggleFavorite(
      userId: params.userId,
      carNo: params.carNo,
    );
  }
}

class ToggleFavoriteParams {
  final String userId;
  final String carNo;

  ToggleFavoriteParams({
    required this.userId,
    required this.carNo,
  });
}
