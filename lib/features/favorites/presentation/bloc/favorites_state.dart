part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoriteAdded extends FavoritesState {
  final Favorite favorite;

  FavoriteAdded({required this.favorite});
}

final class FavoriteRemoved extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;

  FavoritesLoaded({required this.favorites});
}

final class FavoriteStatusChecked extends FavoritesState {
  final bool isFavorited;

  FavoriteStatusChecked({required this.isFavorited});
}

final class FavoriteToggled extends FavoritesState {
  final bool isFavorited;

  FavoriteToggled({required this.isFavorited});
}

final class FavoriteCountLoaded extends FavoritesState {
  final int count;

  FavoriteCountLoaded({required this.count});
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});
}
