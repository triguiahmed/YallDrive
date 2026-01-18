import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_car_card.dart';
import 'package:flutter/material.dart';

class BookingRecentlyViewed extends StatelessWidget {
  final List<CarDetails> recentlyViewedCars;
  const BookingRecentlyViewed({
    super.key,
    required this.recentlyViewedCars,
  });

  @override
  Widget build(BuildContext context) {
    if (recentlyViewedCars.isEmpty) {
      return const Center(child: Text('No recently viewed cars.'));
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentlyViewedCars.length,
        itemBuilder: (context, index) => BookingCarCard(
          car: recentlyViewedCars[index],
        ),
      ),
    );
  }
}
