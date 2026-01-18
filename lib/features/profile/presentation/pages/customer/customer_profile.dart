import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/customer/customer.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/empty_profile_header.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/menu_option.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/profile_header.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/profile_host_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  void _loadUserData(userId) {
    context.read<ProfileBloc>().add(ProfileGetCustomerData(userId: userId));
    context.read<BookingBloc>().add(ShowBookingForUserEvent(userId: userId));
  }

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _loadUserData(userState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      currentIndex: 2,
      title: 'Profile',
      bottomNavItems: Customer.bottomNavbarItems,
      routes: Customer.routes,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFailure) {
                showSnackerbar(context, state.message);
              }
            },
          ),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingFailure) {
                showSnackerbar(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return BlocBuilder<BookingBloc, BookingState>(
              builder: (context, bookingState) {
                bool hasActiveBooking = false;
                if (bookingState is BookingSuccessListBooking) {
                  hasActiveBooking =
                      bookingState.bookings.isEmpty ? false : true;
                }

                if (profileState is ProfileLoading ||
                    bookingState is BookingLoading) {
                  return Loader();
                }

                if (profileState is ProfileCustomerDataSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(
                          customerData: profileState.customerData,
                          onProfileUpdated: () =>
                              _loadUserData(profileState.customerData.id),
                        ),
                        ProfileHostCart(
                          hasActiveBooking: hasActiveBooking,
                        ),
                        MenuOption(),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmptyProfileHeader(),
                      ProfileHostCart(
                        hasActiveBooking: hasActiveBooking,
                      ),
                      MenuOption(),
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
