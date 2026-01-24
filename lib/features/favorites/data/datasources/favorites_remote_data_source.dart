import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaladrive/core/error/exception.dart';
import 'package:yaladrive/features/favorites/data/models/favorite_model.dart';

abstract interface class FavoritesRemoteDataSource {
  Future<FavoriteModel> addFavorite({
    required String userId,
    required String carNo,
  });

  Future<void> removeFavorite({
    required String favoriteId,
    required String userId,
  });

  Future<void> removeFavoriteByCarNo({
    required String userId,
    required String carNo,
  });

  Future<List<FavoriteModel>> getFavoritesByUser({
    required String userId,
  });

  Future<bool> isCarFavorited({
    required String userId,
    required String carNo,
  });

  Future<List<String>> getUsersWhoFavoritedCar({
    required String carNo,
  });

  Future<int> getFavoriteCountForCar({
    required String carNo,
  });

  Future<bool> toggleFavorite({
    required String userId,
    required String carNo,
  });
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore fireStore;

  FavoritesRemoteDataSourceImpl(this.fireStore);

  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      fireStore.collection('favorites');

  @override
  Future<FavoriteModel> addFavorite({
    required String userId,
    required String carNo,
  }) async {
    try {
      // Check if car exists
      final carSnapshot = await fireStore
          .collection('cars')
          .where('carNumber', isEqualTo: carNo)
          .get();

      if (carSnapshot.docs.isEmpty) {
        throw ServerException('Car not found');
      }

      // Check if user exists
      final userSnapshot =
          await fireStore.collection('users').doc(userId).get();

      if (!userSnapshot.exists) {
        throw ServerException('User not found');
      }

      // Check if already favorited
      final existingFavorite = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('carNo', isEqualTo: carNo)
          .get();

      if (existingFavorite.docs.isNotEmpty) {
        throw ServerException('Car is already in favorites');
      }

      // Create new favorite
      final favoriteRef = _favoritesCollection.doc();
      final favorite = FavoriteModel(
        id: favoriteRef.id,
        userId: userId,
        carNo: carNo,
        createdAt: DateTime.now(),
      );

      await favoriteRef.set(favorite.toJson());
      return favorite;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite({
    required String favoriteId,
    required String userId,
  }) async {
    try {
      final favoriteRef = _favoritesCollection.doc(favoriteId);
      final snapshot = await favoriteRef.get();

      if (!snapshot.exists) {
        throw ServerException('Favorite not found');
      }

      final favorite = FavoriteModel.fromJson(snapshot.data()!);

      // Verify ownership
      if (favorite.userId != userId) {
        throw ServerException('You can only remove your own favorites');
      }

      await favoriteRef.delete();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to remove favorite: $e');
    }
  }

  @override
  Future<void> removeFavoriteByCarNo({
    required String userId,
    required String carNo,
  }) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('carNo', isEqualTo: carNo)
          .get();

      if (snapshot.docs.isEmpty) {
        throw ServerException('Favorite not found');
      }

      // Delete the favorite document
      await snapshot.docs.first.reference.delete();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to remove favorite: $e');
    }
  }

  @override
  Future<List<FavoriteModel>> getFavoritesByUser({
    required String userId,
  }) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FavoriteModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isCarFavorited({
    required String userId,
    required String carNo,
  }) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('carNo', isEqualTo: carNo)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw ServerException('Failed to check favorite status: $e');
    }
  }

  @override
  Future<List<String>> getUsersWhoFavoritedCar({
    required String carNo,
  }) async {
    try {
      final snapshot =
          await _favoritesCollection.where('carNo', isEqualTo: carNo).get();

      return snapshot.docs
          .map((doc) => doc.data()['userId'] as String)
          .toList();
    } catch (e) {
      throw ServerException('Failed to get users who favorited car: $e');
    }
  }

  @override
  Future<int> getFavoriteCountForCar({
    required String carNo,
  }) async {
    try {
      final snapshot =
          await _favoritesCollection.where('carNo', isEqualTo: carNo).get();

      return snapshot.docs.length;
    } catch (e) {
      throw ServerException('Failed to get favorite count: $e');
    }
  }

  @override
  Future<bool> toggleFavorite({
    required String userId,
    required String carNo,
  }) async {
    try {
      final isFavorited = await isCarFavorited(userId: userId, carNo: carNo);

      if (isFavorited) {
        await removeFavoriteByCarNo(userId: userId, carNo: carNo);
        return false; // Removed from favorites
      } else {
        await addFavorite(userId: userId, carNo: carNo);
        return true; // Added to favorites
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle favorite: $e');
    }
  }
}
