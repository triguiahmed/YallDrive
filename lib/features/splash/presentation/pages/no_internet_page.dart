import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/utils/retry_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  void navigateBasedOnUserState(BuildContext context, AppUserState state) {
    if (!context.mounted) return;

    String route = AppRoutes.authHome;
    if (state is AppUserLoggedIn) {
      route = (state.user.role == 'CUSTOMER')
          ? AppRoutes.customerHome
          : AppRoutes.ownerHome;
    }

    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        navigateBasedOnUserState(context, state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('No Internet'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
                const SizedBox(height: 20),
                const Text(
                  "No internet connection. Please check your network settings.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => retryConnection(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
