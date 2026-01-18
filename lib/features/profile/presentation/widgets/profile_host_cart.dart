import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:flutter/material.dart';

class ProfileHostCart extends StatelessWidget {
  final bool hasActiveBooking;
  const ProfileHostCart({
    super.key,
    required this.hasActiveBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Become a host",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Join thousands of hosts building businesses and earning meaningful income.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: hasActiveBooking
                          ? () => showSnackerbar(context,
                              "Complete your current booking before becoming a host.")
                          : () => Navigator.pushNamed(
                              context, AppRoutes.registerHome),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Learn more"),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    Constants.hostCarImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
