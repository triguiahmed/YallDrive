class Favorite {
  final String id;
  final String userId;
  final String carNo;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.carNo,
    required this.createdAt,
  });

  Favorite copyWith({
    String? id,
    String? userId,
    String? carNo,
    DateTime? createdAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carNo: carNo ?? this.carNo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
