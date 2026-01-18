import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class Owner {
  static const bottomNavbarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.pending_actions),
      label: 'Requests',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'Cars'),
    BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
  ];

  static const routes = [
    AppRoutes.ownerHome,
    AppRoutes.ownerBookingRequest,
    AppRoutes.ownerCars,
    AppRoutes.ownerProfile,
  ];
}
