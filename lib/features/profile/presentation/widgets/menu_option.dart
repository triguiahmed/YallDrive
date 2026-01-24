import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/core/routes/app_routes.dart';
import 'package:yaladrive/features/favorites/presentation/pages/favorites_page.dart';
import 'package:yaladrive/features/payment/presentation/pages/payment_history_page.dart';
import 'package:yaladrive/features/profile/presentation/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AppUserCubit>().state;
    final userId = userState is AppUserLoggedIn ? userState.user.id : null;

    return Column(
      children: [
        MenuItem(
            icon: Icons.favorite,
            title: "My Favorites",
            onTap: () {
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesPage(userId: userId),
                  ),
                );
              }
            }),
        MenuItem(
            icon: Icons.payment,
            title: "Payment History",
            onTap: () {
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryPage(userId: userId),
                  ),
                );
              }
            }),
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
