import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/routes/app_routes.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/custom_elevated_button.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yaladrive/features/auth/presentation/widgets/auth_field.dart';
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthGoogleSignIn());
                      },
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
