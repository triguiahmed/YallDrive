import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';
import 'package:yaladrive/features/favorites/domain/usecases/add_favorite.dart';
import 'package:yaladrive/features/favorites/domain/usecases/get_favorite_count_for_car.dart';
import 'package:yaladrive/features/favorites/domain/usecases/get_favorites_by_user.dart';
import 'package:yaladrive/features/favorites/domain/usecases/is_car_favorited.dart';
import 'package:yaladrive/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:yaladrive/features/favorites/domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AddFavorite _addFavorite;
  final RemoveFavorite _removeFavorite;
  final GetFavoritesByUser _getFavoritesByUser;
  final IsCarFavorited _isCarFavorited;
  final ToggleFavorite _toggleFavorite;
  final GetFavoriteCountForCar _getFavoriteCountForCar;

  FavoritesBloc({
    required AddFavorite addFavorite,
    required RemoveFavorite removeFavorite,
    required GetFavoritesByUser getFavoritesByUser,
    required IsCarFavorited isCarFavorited,
    required ToggleFavorite toggleFavorite,
    required GetFavoriteCountForCar getFavoriteCountForCar,
  })  : _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _getFavoritesByUser = getFavoritesByUser,
        _isCarFavorited = isCarFavorited,
        _toggleFavorite = toggleFavorite,
        _getFavoriteCountForCar = getFavoriteCountForCar,
        super(FavoritesInitial()) {
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<GetFavoritesByUserEvent>(_onGetFavoritesByUser);
    on<CheckIsFavoritedEvent>(_onCheckIsFavorited);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<GetFavoriteCountEvent>(_onGetFavoriteCount);
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _addFavorite(
      AddFavoriteParams(
        userId: event.userId,
        carNo: event.carNo,
      ),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorite) => emit(FavoriteAdded(favorite: favorite)),
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _removeFavorite(
      RemoveFavoriteParams(
        favoriteId: event.favoriteId,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (_) => emit(FavoriteRemoved()),
    );
  }

  Future<void> _onGetFavoritesByUser(
    GetFavoritesByUserEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _getFavoritesByUser(
      GetFavoritesByUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> _onCheckIsFavorited(
    CheckIsFavoritedEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _isCarFavorited(
      IsCarFavoritedParams(
        userId: event.userId,
        carNo: event.carNo,
      ),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (isFavorited) => emit(FavoriteStatusChecked(isFavorited: isFavorited)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _toggleFavorite(
      ToggleFavoriteParams(
        userId: event.userId,
        carNo: event.carNo,
      ),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (isFavorited) => emit(FavoriteToggled(isFavorited: isFavorited)),
    );
  }

  Future<void> _onGetFavoriteCount(
    GetFavoriteCountEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await _getFavoriteCountForCar(
      GetFavoriteCountParams(carNo: event.carNo),
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (count) => emit(FavoriteCountLoaded(count: count)),
    );
  }
}
