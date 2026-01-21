import 'package:yalladrive/core/routes/app_routes.dart';
import 'package:yalladrive/core/theme/app_pallete.dart';
import 'package:yalladrive/core/common/entities/car_details.dart';
import 'package:flutter/material.dart';

class CarDetail extends StatefulWidget {
  const CarDetail({super.key});

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['car'] == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Car Details')),
        body: Center(child: Text('No car details available')),
      );
    }

    final car = args['car'] as CarDetails;
    bool isBooked = args['isBooked'] as bool;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                car.carUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.car_rental, size: 50)),
                ),
              ),
            ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    car.carName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isBooked ? Icons.close : Icons.check_circle,
                      color: isBooked ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isBooked ? 'Booked' : 'Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isBooked ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              'Car Number: ${car.carNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            Text(
              'Location: ${car.location}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            Text(
              'Price per Day: ${car.pricePerDay.toStringAsFixed(2)}TND',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),

            Divider(),
            SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bookingHome,
                      arguments: {
                        'car': car,
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.gradient1,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
