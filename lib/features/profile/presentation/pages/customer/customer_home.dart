import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_destination_list.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_hero_section.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_recently_viewed.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_section_title.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/bloc/register_bloc.dart';
import 'package:car_rental_app_clean_arch/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<CarDetails> _recentlyViewedCars = [];

  @override
  void initState() {
    super.initState();
    context.read<RegisterBloc>().add(RegisterGetAllCars());
    _loadRecentlyViewedCars();
  }

  Future<void> _loadRecentlyViewedCars() async {
    try {
      final box = serviceLocator<Box>();
      final cars = box.get('recently_viewed_cars', defaultValue: []);

      if (cars is List) {
        setState(() {
          _recentlyViewedCars = cars
              .map((item) => CarDetails(
                    ownerId: item['ownerId'] ?? '',
                    location: item['location'] ?? '',
                    carName: item['carName'] ?? '',
                    carNumber: item['carNumber'] ?? '',
                    isBooked: item['isBooked'] ?? false,
                    pricePerDay: (item['pricePerDay'] ?? 0.0).toDouble(),
                    carUrl: item['carUrl'] ?? '',
                  ))
              .toList();
        });
      } else {
        debugPrint('Unexpected data type for recently viewed cars');
      }
    } catch (e) {
      debugPrint('Failed to load recently viewed cars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      currentIndex: 0,
      bottomNavItems: Customer.bottomNavbarItems,
      routes: Customer.routes,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingHeroSection(
              onLoad: () => _loadRecentlyViewedCars(),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BookingSectionTitle(title: 'Recently viewed'),
                  const SizedBox(height: 15),
                  BookingRecentlyViewed(
                    recentlyViewedCars: _recentlyViewedCars,
                  ),
                  const SizedBox(height: 30),
                  const BookingSectionTitle(title: 'Top destinations'),
                  const SizedBox(height: 15),
                  const BookingDestinationList(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
