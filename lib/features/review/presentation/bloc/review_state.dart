part of 'review_bloc.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewCreated extends ReviewState {
  final Review review;

  ReviewCreated({required this.review});
}

final class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;

  ReviewsLoaded({required this.reviews});
}

final class ReviewUpdated extends ReviewState {
  final Review review;

  ReviewUpdated({required this.review});
}

final class ReviewDeleted extends ReviewState {}

final class AverageRatingLoaded extends ReviewState {
  final double averageRating;

  AverageRatingLoaded({required this.averageRating});
}

final class ReviewError extends ReviewState {
  final String message;

  ReviewError({required this.message});
}
