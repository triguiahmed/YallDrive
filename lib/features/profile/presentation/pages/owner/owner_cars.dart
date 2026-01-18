import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/car_details.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
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
              return const Center(child: Text('No cars available.'));
            }

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                final bool isBooked = _isCarBooked(car.carNumber);

                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15.0)),
                        child: Image.network(
                          car.carUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(car.carName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 5),
                            Text(car.location,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${car.pricePerDay}TND/day',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  isBooked ? Icons.lock : Icons.directions_car,
                                  color: isBooked ? Colors.red : Colors.green,
                                ),
                              ],
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
    );
  }
}
