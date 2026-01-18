import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final CarDetails car;
  final String ownerName;
  const BookingCard({
    super.key,
    required this.booking,
    required this.car,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                car.carUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    car.carName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        ownerName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              booking.carNo,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From ${DateFormat('dd MMM yyyy').format(booking.startDate)} "
                  "to ${DateFormat('dd MMM yyyy').format(booking.endDate)}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Icon(
                  booking.isApproved && booking.paymentStatus == 'Paid'
                      ? Icons.check_circle
                      : booking.paymentStatus == 'Pending' &&
                              !(booking.status == "Denied")
                          ? Icons.hourglass_top
                          : Icons.cancel_rounded,
                  color:
                      booking.isApproved && !(booking.paymentStatus == 'Failed')
                          ? Colors.green
                          : booking.paymentStatus == 'Pending' &&
                                  !(booking.status == "Denied")
                              ? Colors.orange
                              : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Price Paid: ${booking.price.toStringAsFixed(2)}TND",
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: booking.status == "Confirmed"
                        ? Colors.green.shade100
                        : booking.status == "Denied"
                            ? Colors.red.shade100
                            : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Status: ${booking.status}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: booking.status == "Confirmed"
                          ? Colors.green
                          : booking.status == "Denied"
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                ),
                if (booking.status == 'Confirmed')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: booking.paymentStatus == "Paid"
                          ? Colors.green.shade100
                          : booking.paymentStatus == "Failed"
                              ? Colors.red.shade100
                              : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: booking.paymentStatus == "Pending"
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.payment,
                                  arguments: {
                                    'booking': booking,
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Pay"),
                          )
                        : Text(
                            "Payment: ${booking.paymentStatus}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: booking.paymentStatus == "Paid"
                                  ? Colors.green
                                  : booking.paymentStatus == "Failed"
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
