class Review {
  final String id;
  final String carNo;
  final String userId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.carNo,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Review copyWith({
    String? id,
    String? carNo,
    String? userId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      carNo: carNo ?? this.carNo,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
