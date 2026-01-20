/// Payment method types
enum PaymentMethod {
  card,
  wallet,
  cash;

  String get value => name;

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Payment status types
enum PaymentStatus {
  pending,
  paid,
  failed;

  String get value => name;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PaymentStatus.pending,
    );
  }

  /// Validates if a status transition is valid
  /// Valid transitions:
  /// - pending -> paid
  /// - pending -> failed
  /// - failed -> pending (retry)
  bool canTransitionTo(PaymentStatus newStatus) {
    switch (this) {
      case PaymentStatus.pending:
        return newStatus == PaymentStatus.paid ||
            newStatus == PaymentStatus.failed;
      case PaymentStatus.failed:
        return newStatus == PaymentStatus.pending;
      case PaymentStatus.paid:
        return false; // paid is final
    }
  }
}

class Payment {
  final String id;
  final String bookingId;
  final String userId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime? paidAt;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    this.paidAt,
    required this.createdAt,
  });

  Payment copyWith({
    String? id,
    String? bookingId,
    String? userId,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? paidAt,
    DateTime? createdAt,
  }) {
    return Payment(
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
}
