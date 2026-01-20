import 'package:yaladrive/features/review/domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.carNo,
    required super.userId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? carNo,
    String? userId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      carNo: carNo ?? this.carNo,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'carNo': carNo,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String? ?? '',
      carNo: map['carNo'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
    );
  }
}
