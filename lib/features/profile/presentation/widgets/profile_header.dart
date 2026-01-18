import 'package:flutter/material.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/customer_data.dart';

class ProfileHeader extends StatelessWidget {
  final CustomerData customerData;
  final VoidCallback onProfileUpdated;

  const ProfileHeader({
    super.key,
    required this.customerData,
    required this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            backgroundImage: customerData.profileUrl != null &&
                    customerData.profileUrl!.isNotEmpty
                ? NetworkImage(customerData.profileUrl!) as ImageProvider
                : null,
            child: customerData.profileUrl == null ||
                    customerData.profileUrl!.isEmpty
                ? const Icon(Icons.person, size: 40, color: Colors.black54)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerData.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.customerEditProfile,
                  );
                  if (result == true) {
                    onProfileUpdated();
                  }
                },
                child: const Text(
                  "View and edit profile",
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
