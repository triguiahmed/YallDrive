import 'package:car_rental_app_clean_arch/features/profile/domain/entities/owner_data.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';

class OwnerDataModel extends OwnerData {
  OwnerDataModel({
    required super.name,
    required super.profileUrl,
    required super.noOfCars,
    required super.cars,
    required super.id,
  });

  OwnerDataModel copyWith({
    String? name,
    String? profileUrl,
    int? noOfCars,
    List<CarDetailsModel>? cars,
    String? id,
  }) {
    return OwnerDataModel(
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl,
      noOfCars: noOfCars ?? this.noOfCars,
      cars: cars ?? this.cars,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'profileUrl': profileUrl,
      'noOfCars': noOfCars,
      'cars': cars.map((x) => x.toJson()).toList(),
      'id': id,
    };
  }

  factory OwnerDataModel.fromJson(Map<String, dynamic> map) {
    return OwnerDataModel(
      name: map['name'] as String? ?? '',
      profileUrl: map['profileUrl'] as String? ?? '',
      noOfCars: map['noOfCars'] as int? ?? 0,
      cars: (map['cars'] as List<dynamic>?)
              ?.map<CarDetailsModel>(
                  (x) => CarDetailsModel.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      id: map['id'] as String? ?? '',
    );
  }
}
