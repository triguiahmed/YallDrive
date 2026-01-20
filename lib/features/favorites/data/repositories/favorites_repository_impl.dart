import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';
import 'package:yaladrive/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource favoritesRemoteDataSource;

  FavoritesRepositoryImpl(this.favoritesRemoteDataSource);

  @override
  Future<Either<Failure, Favorite>> addFavorite({
    required String userId,
    required String carNo,
  }) async {
    try {
      final favorite = await favoritesRemoteDataSource.addFavorite(
        userId: userId,
        carNo: carNo,
      );
      return Right(favorite);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite({
    required String favoriteId,
    required String userId,
  }) async {
    try {
      await favoritesRemoteDataSource.removeFavorite(
        favoriteId: favoriteId,
        userId: userId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteByCarNo({
    required String userId,
    required String carNo,
  }) async {
    try {
      await favoritesRemoteDataSource.removeFavoriteByCarNo(
        userId: userId,
        carNo: carNo,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Favorite>>> getFavoritesByUser({
    required String userId,
  }) async {
    try {
      final favorites = await favoritesRemoteDataSource.getFavoritesByUser(
        userId: userId,
      );
      return Right(favorites);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isCarFavorited({
    required String userId,
    required String carNo,
  }) async {
    try {
      final isFavorited = await favoritesRemoteDataSource.isCarFavorited(
        userId: userId,
        carNo: carNo,
      );
      return Right(isFavorited);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUsersWhoFavoritedCar({
    required String carNo,
  }) async {
    try {
      final users = await favoritesRemoteDataSource.getUsersWhoFavoritedCar(
        carNo: carNo,
      );
      return Right(users);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getFavoriteCountForCar({
    required String carNo,
  }) async {
    try {
      final count = await favoritesRemoteDataSource.getFavoriteCountForCar(
        carNo: carNo,
      );
      return Right(count);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite({
    required String userId,
    required String carNo,
  }) async {
    try {
      final isFavorited = await favoritesRemoteDataSource.toggleFavorite(
        userId: userId,
        carNo: carNo,
      );
      return Right(isFavorited);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
