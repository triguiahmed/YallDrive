import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuItem(
            icon: Icons.support_agent,
            title: "Contact Support",
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.customerHelp,
              );
            }),
        MenuItem(
            icon: Icons.logout,
            title: "Log out",
            onTap: () {
              context.read<AppUserCubit>().logOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.authHome,
                (route) => false,
              );
            }),
      ],
    );
  }
}
