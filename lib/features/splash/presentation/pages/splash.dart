import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerBar.dart';
import 'package:car_rental_app_clean_arch/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetAndProceed();
  }

  Future<void> _checkInternetAndProceed() async {
    final internetChecker = InternetConnection();
    bool hasInternet = await internetChecker.hasInternetAccess;
    if (hasInternet) {
      context.read<SplashBloc>().add(LoadSplashEvent());
    } else {
      Navigator.pushNamed(context, AppRoutes.noInternet);
    }
  }

  void navigateBasedOnUserState(BuildContext context, AppUserState state) {
    if (state is AppUserLoggedIn) {
      if (state.user.role == 'CUSTOMER') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.customerHome,
          (route) => false,
        );
      } else if (state.user.role == 'OWNER') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.ownerHome,
          (route) => false,
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.authHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MultiBlocListener(
            listeners: [
              BlocListener<SplashBloc, SplashState>(
                listener: (context, state) {
                  if (state is SplashFailure) {
                    showSnackerbar(context, state.message);
                  }
                },
              ),
              BlocListener<AppUserCubit, AppUserState>(
                listener: (context, state) {
                  navigateBasedOnUserState(context, state);
                },
              ),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Constants.splashImg,
                  height: 150,
                ),
                Text(
                  'YallaDrive',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.headerFontcolor,
                      letterSpacing: 2,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 10),
                Text(
                  'Find your ride, anytime, anywhere!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
                CircularProgressIndicator(
                  color: AppPallete.blackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
