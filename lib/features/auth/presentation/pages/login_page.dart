import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/custom_elevated_button.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_rental_app_clean_arch/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackerbar(context, state.message);
            }
            if (state is AuthSuccess) {
              context.read<AppUserCubit>().fetchUser().then((_) {
                if (!mounted)
                  return; 

                final userState = context.read<AppUserCubit>().state;
                if (userState is AppUserLoggedIn) {
                  if (userState.user.role == 'CUSTOMER') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.customerHome,
                      (route) => false,
                    );
                  } else if (userState.user.role == 'OWNER') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.ownerHome,
                      (route) => false,
                    );
                  }
                }
              });
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                    isObscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        }
                      },
                      buttonText: 'Sign In',
                      textColor: AppPallete.whiteColor,
                      buttonColor: AppPallete.gradient1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
