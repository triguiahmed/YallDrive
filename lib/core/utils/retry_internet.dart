import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> retryConnection(BuildContext context) async {
  final appUserCubit = context.read<AppUserCubit>();

  while (true) {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet && context.mounted) {
      final state = appUserCubit.state;

      String route = AppRoutes.authHome; // Default to Auth Home
      if (state is AppUserLoggedIn) {
        route = (state.user.role == 'CUSTOMER') 
            ? AppRoutes.customerHome 
            : AppRoutes.ownerHome;
      }

      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacementNamed(context, route);
      }
      break;
    }
    await Future.delayed(const Duration(seconds: 2)); 
  }
}
