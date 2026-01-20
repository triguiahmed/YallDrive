part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

final class CreateReviewEvent extends ReviewEvent {
  final String carNo;
  final String userId;
  final int rating;
  final String comment;

  CreateReviewEvent({
    required this.carNo,
    required this.userId,
    required this.rating,
    required this.comment,
  });
}

final class GetReviewsForCarEvent extends ReviewEvent {
  final String carNo;

  GetReviewsForCarEvent({
    required this.carNo,
  });
}

final class GetReviewsByUserEvent extends ReviewEvent {
  final String userId;

  GetReviewsByUserEvent({
    required this.userId,
  });
}

final class UpdateReviewEvent extends ReviewEvent {
  final String reviewId;
  final String userId;
  final int? rating;
  final String? comment;

  UpdateReviewEvent({
    required this.reviewId,
    required this.userId,
    this.rating,
    this.comment,
  });
}

final class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;
  final String userId;

  DeleteReviewEvent({
    required this.reviewId,
    required this.userId,
  });
}

final class GetAverageRatingEvent extends ReviewEvent {
  final String carNo;

  GetAverageRatingEvent({
    required this.carNo,
  });
}
