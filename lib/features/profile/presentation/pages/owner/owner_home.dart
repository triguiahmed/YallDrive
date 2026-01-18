import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  int noOfCars = 0;

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(
            ProfileGetOwnerCars(ownerId: userState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dummyFeedbacks = [
      'Great service! The car was in excellent condition.',
      'Smooth booking process and friendly staff.',
      'Had a minor issue, but support resolved it quickly.',
      'Highly recommend this platform for car rentals.',
    ];

    return ScaffoldPage(
      title: 'Welcome to YallaDrive',
      currentIndex: 0,
      bottomNavItems: Owner.bottomNavbarItems,
      routes: Owner.routes,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            showSnackerbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Loader();
          }

          if (state is ProfileOwnerCarsSuccess) {
            noOfCars = state.cars.length;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppPallete.gradient3.withAlpha(220),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Registred Cars: $noOfCars',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.registerForm,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Register New Car',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: dummyFeedbacks.length,
                    itemBuilder: (context, index) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white.withAlpha(200),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          dummyFeedbacks[index],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
