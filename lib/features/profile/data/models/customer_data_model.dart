import 'package:car_rental_app_clean_arch/features/profile/domain/entities/customer_data.dart';

class CustomerDataModel extends CustomerData {
  CustomerDataModel({
    required super.name,
    required super.profileUrl,
    required super.id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'profileUrl': profileUrl,
    };
  }

  factory CustomerDataModel.fromJson(Map<String, dynamic> map) {
  return CustomerDataModel(
    name: map['name'] ?? '', 
    profileUrl: map['profileUrl'] as String?, 
    id: map['id'] as String, 
  );
}

  CustomerDataModel copyWith({
    String? id,
    String? name,
    String? profileUrl,
  }) {
    return CustomerDataModel(
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl,
      id: id ?? this.id,
    );
  }
}
