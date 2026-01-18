import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/utils/car_by_id.dart';
import 'package:car_rental_app_clean_arch/core/utils/get_Owner.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/owner_data_model.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_card.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_error.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBooking extends StatefulWidget {
  const CustomerBooking({super.key});

  @override
  State<CustomerBooking> createState() => _CustomerBookingState();
}

class _CustomerBookingState extends State<CustomerBooking> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      context.read<BookingBloc>().add(
            ShowBookingForUserEvent(userId: userState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      currentIndex: 1,
      bottomNavItems: Customer.bottomNavbarItems,
      routes: Customer.routes,
      title: 'My Bookings',
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingFailure) {
            showSnackerbar(context, state.message);
          } else if (state is BookingSuccessListBooking) {
            setState(() {
              bookings = state.bookings;
            });
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Loader();
          }

          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return FutureBuilder<CarDetailsModel>(
                future: fetchCarById(booking.carNo),
                builder: (context, carSnapshot) {
                  if (carSnapshot.connectionState == ConnectionState.waiting) {
                    return Loader();
                  } else if (carSnapshot.hasError) {
                    return BookingError(
                      message: "Error loading car details",
                    );
                  } else if (!carSnapshot.hasData) {
                    return SizedBox(); 
                  }

                  final car = carSnapshot.data!;

                  return FutureBuilder<OwnerDataModel>(
                    future: getOwner(car.ownerId),
                    builder: (context, ownerSnapshot) {
                      String ownerName = "Loading...";
                      if (ownerSnapshot.connectionState ==
                          ConnectionState.done) {
                        if (ownerSnapshot.hasError) {
                          ownerName = "Owner not found";
                        } else if (ownerSnapshot.hasData) {
                          ownerName = ownerSnapshot.data!.name;
                        }
                      }
                      
                      return BookingCard(
                        booking: booking,
                        car: car,
                        ownerName: ownerName,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
