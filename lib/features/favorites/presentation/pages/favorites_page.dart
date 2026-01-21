import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';
import 'package:yaladrive/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:yaladrive/features/favorites/presentation/widgets/favorite_car_card.dart';
import 'package:yaladrive/init_dependencies.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;

  const FavoritesPage({
    super.key,
    required this.userId,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Favorite> _favorites = [];
  Map<String, Map<String, dynamic>> _carDetails = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    context.read<FavoritesBloc>().add(
          GetFavoritesByUserEvent(userId: widget.userId),
        );
  }

  Future<void> _loadCarDetails(List<Favorite> favorites) async {
    final firestore = serviceLocator<FirebaseFirestore>();

    for (final favorite in favorites) {
      if (!_carDetails.containsKey(favorite.carNo)) {
        try {
          final carSnapshot = await firestore
              .collection('cars')
              .where('carNumber', isEqualTo: favorite.carNo)
              .limit(1)
              .get();

          if (carSnapshot.docs.isNotEmpty) {
            _carDetails[favorite.carNo] = carSnapshot.docs.first.data();
          }
        } catch (e) {
          debugPrint('Error loading car details: $e');
        }
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: AppPallete.gradient1,
        foregroundColor: Colors.white,
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _confirmClearAll,
              tooltip: 'Clear all favorites',
            ),
        ],
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesError) {
            showSnackBar(context, state.message);
          } else if (state is FavoritesLoaded) {
            _favorites = state.favorites;
            _loadCarDetails(state.favorites);
          } else if (state is FavoriteRemoved) {
            showSnackBar(context, 'Removed from favorites');
            _loadFavorites();
          } else if (state is FavoriteToggled) {
            if (!state.isFavorited) {
              showSnackBar(context, 'Removed from favorites');
            }
            _loadFavorites();
          }
        },
        builder: (context, state) {
          if (state is FavoritesLoading && _favorites.isEmpty) {
            return const Loader();
          }

          if (_favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding cars to your favorites!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.search),
                    label: const Text('Browse Cars'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.gradient1,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final favorite = _favorites[index];
                final carData = _carDetails[favorite.carNo];

                return FavoriteCarCard(
                  favorite: favorite,
                  carName: carData?['carName'],
                  carImageUrl: carData?['carUrl'],
                  pricePerDay: carData?['pricePerDay']?.toDouble(),
                  location: carData?['location'],
                  onTap: () => _navigateToCarDetails(favorite.carNo),
                  onRemove: () => _confirmRemoveFavorite(favorite),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToCarDetails(String carNo) {
    // Navigate to car details page
    // You can implement this based on your app's navigation
    Navigator.pop(context, carNo);
  }

  void _confirmRemoveFavorite(Favorite favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: const Text(
          'Are you sure you want to remove this car from your favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FavoritesBloc>().add(
                    RemoveFavoriteEvent(
                      favoriteId: favorite.id,
                      userId: widget.userId,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all cars from your favorites? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites() async {
    for (final favorite in _favorites) {
      context.read<FavoritesBloc>().add(
            RemoveFavoriteEvent(
              favoriteId: favorite.id,
              userId: widget.userId,
            ),
          );
    }
  }
}
