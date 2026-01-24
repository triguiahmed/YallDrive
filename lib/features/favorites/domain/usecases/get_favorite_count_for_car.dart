import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/core/usecase/usecase.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoriteCountForCar implements Usecase<int, GetFavoriteCountParams> {
  final FavoritesRepository favoritesRepository;

  GetFavoriteCountForCar(this.favoritesRepository);

  @override
  Future<Either<Failure, int>> call(GetFavoriteCountParams params) async {
    return await favoritesRepository.getFavoriteCountForCar(
      carNo: params.carNo,
    );
  }
}

class GetFavoriteCountParams {
  final String carNo;

  GetFavoriteCountParams({
    required this.carNo,
  });
}
