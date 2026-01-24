part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

final class AddFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String carNo;

  AddFavoriteEvent({
    required this.userId,
    required this.carNo,
  });
}

final class RemoveFavoriteEvent extends FavoritesEvent {
  final String favoriteId;
  final String userId;

  RemoveFavoriteEvent({
    required this.favoriteId,
    required this.userId,
  });
}

final class GetFavoritesByUserEvent extends FavoritesEvent {
  final String userId;

  GetFavoritesByUserEvent({
    required this.userId,
  });
}

final class CheckIsFavoritedEvent extends FavoritesEvent {
  final String userId;
  final String carNo;

  CheckIsFavoritedEvent({
    required this.userId,
    required this.carNo,
  });
}

final class ToggleFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String carNo;

  ToggleFavoriteEvent({
    required this.userId,
    required this.carNo,
  });
}

final class GetFavoriteCountEvent extends FavoritesEvent {
  final String carNo;

  GetFavoriteCountEvent({
    required this.carNo,
  });
}
