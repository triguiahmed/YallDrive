class Booking {
  final String id;
  final String userId;
  final String carNo;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String status;
  final bool isApproved;
  final String ownerId; // Booking status (Confirmed, Completed)
  final String paymentStatus; // Payment status (Paid, Pending, Failed)
  // Payment mode (Card, UPI, Cash, etc.)

  Booking({
    required this.id,
    required this.userId,
    required this.carNo,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.isApproved,
    required this.ownerId,
    required this.paymentStatus,
    // required this.paymentMethod,
  });
}
