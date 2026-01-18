import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Constants.homePageBgImg,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Text(
                  'Find your drive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.signUp,
                          );
                        },
                        buttonText: 'Sign up',
                        textColor: AppPallete.whiteColor,
                        buttonColor: AppPallete.purpleColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.signIn
                          );
                        },
                        buttonText: 'Login',
                        textColor: AppPallete.blackColor,
                        buttonColor: AppPallete.whiteColor,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
