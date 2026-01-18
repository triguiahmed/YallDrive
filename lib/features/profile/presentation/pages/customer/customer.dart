import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class Customer {
  static const bottomNavbarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Trips'),
    BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
  ];

  static const routes = [
    AppRoutes.customerHome,
    AppRoutes.customerBooking,
    AppRoutes.customerProfile,
  ];
}
