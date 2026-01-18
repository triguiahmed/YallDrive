import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/utils/car_by_id.dart';
import 'package:car_rental_app_clean_arch/core/utils/format_date.dart';
import 'package:car_rental_app_clean_arch/core/utils/user_by_id.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/notification/send_notification.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/customer_data_model.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:car_rental_app_clean_arch/features/register/data/models/car_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerBookingRequest extends StatefulWidget {
  const OwnerBookingRequest({super.key});

  @override
  _OwnerBookingRequestState createState() => _OwnerBookingRequestState();
}

class _OwnerBookingRequestState extends State<OwnerBookingRequest> {
  dynamic owner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<AppUserCubit>().state;
      if (userState is AppUserLoggedIn) {
        setState(() {
          owner = userState.user;
        });
        context
            .read<BookingBloc>()
            .add(ShowBookingForOwnerEvent(ownerId: owner.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      title: 'Booking Requests',
      currentIndex: 1,
      bottomNavItems: Owner.bottomNavbarItems,
      routes: Owner.routes,
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return Loader();
          } else if (state is BookingFailure) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16)));
          } else if (state is BookingSuccessListBooking) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Text(
                  'No Booking Requests Found.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }
            return _buildBookingList(state.bookings);
          }
          return const Center(
            child: Text(
              'No Booking Requests Found.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return FutureBuilder<CarDetailsModel>(
          future: fetchCarById(booking.carNo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Car details not found.'));
            }

            final carDetails = snapshot.data!;
            return FutureBuilder<CustomerDataModel>(
              future: getUser(booking.userId),
              builder: (context, customerSnapshot) {
                String customerName = "";
                if (customerSnapshot.connectionState == ConnectionState.done) {
                  customerName = customerSnapshot.hasData
                      ? customerSnapshot.data!.name
                      : "Customer not found";
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: Image.network(carDetails.carUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(carDetails.carName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Chip(
                                  label: Text(customerName),
                                  backgroundColor: Colors.blue.shade100,
                                ),
                              ],
                            ),
                            Text('Car Number: ${booking.carNo}',
                                style: TextStyle(color: Colors.grey[700])),
                            Text(
                              'From ${formatDate(booking.startDate)} to ${formatDate(booking.endDate)}',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              'Price Paid: ${booking.price}TND',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (booking.isApproved == true)
                                  const Chip(
                                    label: Text('Confirmed',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green,
                                  )
                                else if (booking.isApproved == false &&
                                    booking.status == 'Denied')
                                  const Chip(
                                    label: Text('Denied',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                  )
                                else
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () => _updateBookingStatus(
                                            booking, true, booking.carNo),
                                        child: const Text('Approve',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () => _updateBookingStatus(
                                            booking, false, booking.carNo),
                                        child: const Text(
                                          'Deny',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _updateBookingStatus(
    Booking booking,
    bool isApproved,
    String carNo,
  ) async {
    if (!mounted) return;

    context.read<BookingBloc>().add(
          OwnerRequestApproveEvent(
            ownerId: owner.id,
            isApproved: isApproved,
            bookingId: booking.id,
          ),
        );

    final DateTime now = DateTime.now();
    bool isBooked = isApproved &&
        now.isAfter(
          booking.startDate,
        ) &&
        now.isBefore(
          booking.endDate,
        );

    context.read<ProfileBloc>().add(
          ProfileCheckIsBooked(
            carNo: carNo,
            isBooked: isBooked,
          ),
        );

    final customerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(booking.userId)
        .get();

    if (customerDoc.exists) {
      String? customerFcmToken = customerDoc.data()?['fcmtoken'];
      if (customerFcmToken != null) {
        await sendPushNotification(
          customerFcmToken,
          isApproved
              ? "Your booking has been approved! 🚗"
              : "Your booking request was denied. ❌",
          'Car Rental APP',
        );
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context
          .read<BookingBloc>()
          .add(ShowBookingForOwnerEvent(ownerId: owner.id));
    });
  }
}
