import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/utils/count_car_by_location.dart';
import 'package:car_rental_app_clean_arch/core/utils/get_random_color.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/booking_destination_card.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDestinationList extends StatelessWidget {
  const BookingDestinationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state is RegisterLoading) {
          return Loader();
        } else if (state is RegisterGetListCarsSuccess) {
          final cars = state.cars;
          final carCounts = countCarByLocation(cars);

          return SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: carCounts.entries.map((entry) {
                  return BookingDestinationCard(
                    city: entry.key,
                    carCount: '${entry.value} cars',
                    color: getRandomColor(),
                  );
                }).toList(),
              ),
            ),
          );
        } else if (state is RegisterFailure) {
          showSnackerbar(context, state.message);
        }
        return const SizedBox();
      },
    );
  }
}
