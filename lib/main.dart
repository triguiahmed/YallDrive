import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/theme.dart';
import 'package:car_rental_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/bloc/register_bloc.dart';
import 'package:car_rental_app_clean_arch/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:car_rental_app_clean_arch/firebase_options.dart';
import 'package:car_rental_app_clean_arch/init_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<SplashBloc>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<RegisterBloc>()),
        BlocProvider(create: (_) => serviceLocator<ProfileBloc>()),
        BlocProvider(create: (_) => serviceLocator<BookingBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeMode,
      initialRoute: '/',
      routes: AppRoutes.getRoutes(context),
    );
  }
}
