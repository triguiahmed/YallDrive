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
  final String carNo;

  FavoriteStatusChecked({required this.isFavorited, required this.carNo});
}

final class FavoriteToggled extends FavoritesState {
  final bool isFavorited;
  final String carNo;

  FavoriteToggled({required this.isFavorited, required this.carNo});
}

final class FavoriteCountLoaded extends FavoritesState {
  final int count;

  FavoriteCountLoaded({required this.count});
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});
}
