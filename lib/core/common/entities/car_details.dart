class CarDetails {
  final String ownerId;
  final String location;
  final String carName;
  final String carNumber;
  bool isBooked;
  final double pricePerDay;
  final String carUrl;

  CarDetails({
    required this.ownerId,
    required this.location,
    required this.carName,
    required this.carNumber,
    required this.isBooked,
    required this.pricePerDay,
    required this.carUrl,
  });
}
