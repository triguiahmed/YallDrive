import 'package:car_rental_app_clean_arch/features/auth/presentation/pages/login_page.dart';
import 'package:car_rental_app_clean_arch/features/auth/presentation/pages/sign_up_page.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/pages/booking_home.dart';
import 'package:car_rental_app_clean_arch/features/payment/payment.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer_booking.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer_help.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer_home.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer_profile.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer_update_user.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner_booking_request.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner_cars.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner_home.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner_profile.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner_revenue.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/pages/car_detail.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/pages/get_cars.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/pages/register_form.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/pages/register_home.dart';
import 'package:car_rental_app_clean_arch/features/splash/presentation/pages/home_page.dart';
import 'package:car_rental_app_clean_arch/features/splash/presentation/pages/no_internet_page.dart';
import 'package:car_rental_app_clean_arch/features/splash/presentation/pages/splash.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // General
  static const String splash = '/';
  static const String authHome = 'auth/home';
  static const String noInternet = '/noInternet';

  // Auth
  static const String signUp = 'auth/signup';
  static const String signIn = 'auth/signin';

  // Customer
  static const String customerHome = 'customer/home';
  static const String customerProfile = 'customer/profile';
  static const String customerEditProfile = 'customer/edit';
  static const String customerBooking = 'customer/booking';
  static const String customerHelp = 'customer/help';

  // Owner
  static const String ownerHome = 'owner/home';
  static const String ownerProfile = 'owner/profile';
  static const String ownerCars = 'owner/cars';
  static const String ownerBookingRequest = 'owner/bookingRequest';
  static const String ownerRevenue = 'owner/revenue';

  // Register
  static const String registerHome = 'register/home';
  static const String registerForm = 'register/form';
  static const String getCarsByLocation = 'register/cars';
  static const String carDetails = 'register/carDetails';

  // Booking
  static const String bookingHome = 'booking/home';

  // Payment
  static const String payment = 'payment/home';

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      splash: (context) => SplashScreen(),
      authHome: (context) => HomePage(),
      noInternet: (context) => NoInternetPage(),
      signUp: (context) => SignUpPage(),
      customerHome: (context) => CustomerHomeScreen(),
      customerProfile: (context) => CustomerProfileScreen(),
      customerEditProfile: (context) => EditProfileScreen(),
      customerBooking: (context) => CustomerBooking(),
      customerHelp: (context) => CustomerHelp(),
      ownerHome: (context) => OwnerHome(),
      ownerProfile: (context) => OwnerProfileScreen(),
      ownerCars: (context) => OwnerCars(),
      ownerBookingRequest: (context) => OwnerBookingRequest(),
      ownerRevenue: (context) => OwnerRevenue(),
      signIn: (context) => LoginPage(),
      registerHome: (context) => RegisterHome(),
      registerForm: (context) => RegisterForm(),
      getCarsByLocation: (context) => GetCars(),
      carDetails: (context) => CarDetail(),
      bookingHome: (context) => BookingHome(),
      payment: (context) => PaymentScreen(),
    };
  }
}
