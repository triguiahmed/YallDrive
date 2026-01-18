import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.userId,
    required super.carNo,
    required super.startDate,
    required super.endDate,
    required super.price,
    required super.status,
    required super.isApproved,
    required super.ownerId,
    required super.id,
    required super.paymentStatus,
  });

  BookingModel copyWith(
      {String? userId,
      String? carNo,
      DateTime? startDate,
      DateTime? endDate,
      double? price,
      String? status,
      bool? isApproved,
      String? ownerId,
      String? id,
      String? paymentStatus}) {
    return BookingModel(
      userId: userId ?? this.userId,
      carNo: carNo ?? this.carNo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
      status: status ?? this.status,
      isApproved: isApproved ?? this.isApproved,
      ownerId: ownerId ?? this.ownerId,
      id: id ?? this.id,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'carNo': carNo,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'price': price,
      'status': status,
      'ownerId': ownerId,
      'isApproved': isApproved,
      'id': id,
      'paymentStatus': paymentStatus,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> map) {
    return BookingModel(
      userId: map['userId'] as String? ?? '',
      carNo: map['carNo'] as String? ?? '',
      startDate:
          DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int? ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int? ?? 0),
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as double? ?? 0.0),
      status: map['status'] as String? ?? '',
      isApproved: map['isApproved'] as bool? ?? false,
      ownerId: map['ownerId'] as String? ?? '',
      id: map['id'] as String? ?? '',
      paymentStatus: map['paymentStatus'] as String? ?? '',
    );
  }
}
