import 'package:car_rental_app_clean_arch/core/common/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    required super.fcmtoken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      fcmtoken: json['fcmtoken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'fcmtoken': fcmtoken,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'fcmtoken': fcmtoken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      fcmtoken: map['fcmtoken'] as String,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? createdAt,
    String? fcmtoken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      fcmtoken: fcmtoken ?? this.fcmtoken,
    );
  }
}
