import 'package:yaladrive/features/favorites/domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  FavoriteModel({
    required super.id,
    required super.userId,
    required super.carNo,
    required super.createdAt,
  });

  @override
  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? carNo,
    DateTime? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carNo: carNo ?? this.carNo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'carNo': carNo,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      carNo: map['carNo'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
    );
  }
}
