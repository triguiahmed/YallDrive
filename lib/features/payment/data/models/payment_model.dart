import 'package:yaladrive/features/payment/domain/entities/payment.dart';

class PaymentModel extends Payment {
  PaymentModel({
    required super.id,
    required super.bookingId,
    required super.userId,
    required super.amount,
    required super.method,
    required super.status,
    super.paidAt,
    required super.createdAt,
  });

  @override
  PaymentModel copyWith({
    String? id,
    String? bookingId,
    String? userId,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? paidAt,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'method': method.value,
      'status': status.value,
      'paidAt': paidAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as String? ?? '',
      bookingId: map['bookingId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] as double? ?? 0.0),
      method: PaymentMethod.fromString(map['method'] as String? ?? 'cash'),
      status: PaymentStatus.fromString(map['status'] as String? ?? 'pending'),
      paidAt: map['paidAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['paidAt'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
    );
  }
}
