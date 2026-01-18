import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/widgets/register_info_card.dart';
import 'package:flutter/material.dart';

class RegisterHome extends StatelessWidget {
  const RegisterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    Constants.hostCarImage,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Become a host',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Constants.registerHeadingText,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  RegisterInfoCard(Constants.registerTitleText1,
                      Constants.registerDescriptionText1),
                  RegisterInfoCard(Constants.registerTitleText2,
                      Constants.registerDescriptionText2),
                  RegisterInfoCard(Constants.registerTitleText3,
                      Constants.registerDescriptionText3),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.gradient1,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.registerForm,
                    );
                  },
                  child: Text('Get started', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
