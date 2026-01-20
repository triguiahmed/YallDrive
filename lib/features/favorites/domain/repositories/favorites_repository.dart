import 'package:fpdart/fpdart.dart';
import 'package:yaladrive/core/error/failure.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';

abstract interface class FavoritesRepository {
  /// Add a car to favorites
  /// Validates that user hasn't already favorited this car
  Future<Either<Failure, Favorite>> addFavorite({
    required String userId,
    required String carNo,
  });

  /// Remove a car from favorites
  Future<Either<Failure, void>> removeFavorite({
    required String favoriteId,
    required String userId,
  });

  /// Remove a favorite by userId and carNo
  Future<Either<Failure, void>> removeFavoriteByCarNo({
    required String userId,
    required String carNo,
  });

  /// Get all favorites for a user
  Future<Either<Failure, List<Favorite>>> getFavoritesByUser({
    required String userId,
  });

  /// Check if a car is favorited by a user
  Future<Either<Failure, bool>> isCarFavorited({
    required String userId,
    required String carNo,
  });

  /// Get users who favorited a specific car
  Future<Either<Failure, List<String>>> getUsersWhoFavoritedCar({
    required String carNo,
  });

  /// Get favorite count for a car
  Future<Either<Failure, int>> getFavoriteCountForCar({
    required String carNo,
  });

  /// Toggle favorite status (add if not favorited, remove if favorited)
  Future<Either<Failure, bool>> toggleFavorite({
    required String userId,
    required String carNo,
  });
}
