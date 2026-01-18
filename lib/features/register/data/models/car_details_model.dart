import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';

class CarDetailsModel extends CarDetails {
  CarDetailsModel({
    required super.ownerId,
    required super.location,
    required super.carName,
    required super.carNumber,
    required super.isBooked,
    required super.pricePerDay,
    required super.carUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'location': location,
      'carName': carName,
      'carNumber': carNumber,
      'isBooked': isBooked,
      'pricePerDay': pricePerDay,
      'carImage': carUrl,
    };
  }

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    return CarDetailsModel(
      carNumber: json['carNumber'] as String? ?? '',
      location: json['location'] as String? ?? '',
      carName: json['carName'] as String? ?? '',
      carUrl: json['carImage'] as String? ?? '',
      isBooked: json['isBooked'] as bool? ?? false,
      ownerId: json['ownerId'] as String? ?? '',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
