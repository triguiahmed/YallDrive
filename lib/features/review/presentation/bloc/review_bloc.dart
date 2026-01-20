import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/domain/usecases/create_review.dart';
import 'package:yaladrive/features/review/domain/usecases/delete_review.dart';
import 'package:yaladrive/features/review/domain/usecases/get_average_rating_for_car.dart';
import 'package:yaladrive/features/review/domain/usecases/get_reviews_by_user.dart';
import 'package:yaladrive/features/review/domain/usecases/get_reviews_for_car.dart';
import 'package:yaladrive/features/review/domain/usecases/update_review.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final CreateReview _createReview;
  final GetReviewsForCar _getReviewsForCar;
  final GetReviewsByUser _getReviewsByUser;
  final UpdateReview _updateReview;
  final DeleteReview _deleteReview;
  final GetAverageRatingForCar _getAverageRatingForCar;

  ReviewBloc({
    required CreateReview createReview,
    required GetReviewsForCar getReviewsForCar,
    required GetReviewsByUser getReviewsByUser,
    required UpdateReview updateReview,
    required DeleteReview deleteReview,
    required GetAverageRatingForCar getAverageRatingForCar,
  })  : _createReview = createReview,
        _getReviewsForCar = getReviewsForCar,
        _getReviewsByUser = getReviewsByUser,
        _updateReview = updateReview,
        _deleteReview = deleteReview,
        _getAverageRatingForCar = getAverageRatingForCar,
        super(ReviewInitial()) {
    on<CreateReviewEvent>(_onCreateReview);
    on<GetReviewsForCarEvent>(_onGetReviewsForCar);
    on<GetReviewsByUserEvent>(_onGetReviewsByUser);
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<GetAverageRatingEvent>(_onGetAverageRating);
  }

  Future<void> _onCreateReview(
    CreateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _createReview(
      CreateReviewParams(
        carNo: event.carNo,
        userId: event.userId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (review) => emit(ReviewCreated(review: review)),
    );
  }

  Future<void> _onGetReviewsForCar(
    GetReviewsForCarEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _getReviewsForCar(
      GetReviewsForCarParams(carNo: event.carNo),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews: reviews)),
    );
  }

  Future<void> _onGetReviewsByUser(
    GetReviewsByUserEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _getReviewsByUser(
      GetReviewsByUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews: reviews)),
    );
  }

  Future<void> _onUpdateReview(
    UpdateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _updateReview(
      UpdateReviewParams(
        reviewId: event.reviewId,
        userId: event.userId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (review) => emit(ReviewUpdated(review: review)),
    );
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _deleteReview(
      DeleteReviewParams(
        reviewId: event.reviewId,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (_) => emit(ReviewDeleted()),
    );
  }

  Future<void> _onGetAverageRating(
    GetAverageRatingEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _getAverageRatingForCar(
      GetAverageRatingParams(carNo: event.carNo),
    );

    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (rating) => emit(AverageRatingLoaded(averageRating: rating)),
    );
  }
}
