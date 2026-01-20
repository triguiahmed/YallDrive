import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/features/booking/domain/entites/booking.dart';
import 'package:yaladrive/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:yaladrive/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:yaladrive/core/common/entities/car_details.dart';
import 'package:flutter/material.dart';
import 'package:yaladrive/features/profile/presentation/pages/owner/owner.dart';
import 'package:yaladrive/features/profile/presentation/pages/scaffold_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerCars extends StatefulWidget {
  const OwnerCars({super.key});

  @override
  State<OwnerCars> createState() => _OwnerCarsState();
}

class _OwnerCarsState extends State<OwnerCars> {
  List<CarDetails> cars = [];
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _loadCar(userState.user.id);
      _loadBookings(userState.user.id);
    }
  }

  void _loadCar(String ownerId) {
    context.read<ProfileBloc>().add(ProfileGetOwnerCars(ownerId: ownerId));
  }

  void _loadBookings(String ownerId) {
    context.read<BookingBloc>().add(ShowBookingForOwnerEvent(ownerId: ownerId));
  }

  bool _isCarBooked(String carNumber) {
    final DateTime now = DateTime.now();
    return bookings.any((booking) =>
        booking.carNo == carNumber &&
        booking.isApproved &&
        now.isAfter(booking.startDate) &&
        now.isBefore(booking.endDate));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      currentIndex: 2,
      bottomNavItems: Owner.bottomNavbarItems,
      routes: Owner.routes,
      title: 'Your Cars',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppPallete.gradient3.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileFailure) {
                  showSnackerbar(context, state.message);
                }
                if (state is ProfileOwnerCarsSuccess) {
                  setState(() {
                    cars = state.cars;
                  });
                }
              },
            ),
            BlocListener<BookingBloc, BookingState>(
              listener: (context, state) {
                if (state is BookingSuccessListBooking) {
                  setState(() {
                    bookings = state.bookings;
                  });
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Loader();
              }

              if (cars.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.garage_outlined,
                        size: 80,
                        color: AppPallete.gradient3.withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Cars Available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Register your first car to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  final bool isBooked = _isCarBooked(car.carNumber);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.gradient3.withOpacity(0.15),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Car Image with Status Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                              child: Image.network(
                                car.carUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Status Badge
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isBooked
                                        ? [Colors.red.shade400, Colors.red.shade600]
                                        : [Colors.green.shade400, Colors.green.shade600],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isBooked ? Icons.lock : Icons.check_circle,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      isBooked ? 'Booked' : 'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Car Name
                              Text(
                                car.carName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 12),
                              
                              // Location
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppPallete.gradient3.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      color: AppPallete.gradient3,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      car.location,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              
                              // Car Number
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppPallete.gradient3.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.confirmation_number,
                                      color: AppPallete.gradient3,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    car.carNumber,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              
                              // Price Container
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppPallete.gradient1.withOpacity(0.15),
                                      AppPallete.gradient2.withOpacity(0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppPallete.gradient3.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.payments,
                                          color: AppPallete.gradient3,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Price per Day',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${car.pricePerDay} TND',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppPallete.gradient3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}