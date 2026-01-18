import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/profile/domain/entities/owner_data.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/owner/owner.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _loadUserData(userState.user.id);
    }
  }

  void _loadUserData(String userId) {
    context.read<ProfileBloc>().add(ProfileGetOwnerData(ownerId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return ScaffoldPage(
      currentIndex: 3,
      title: 'Profile',
      bottomNavItems: Owner.bottomNavbarItems,
      routes: Owner.routes,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            showSnackerbar(context, state.message);
          } 
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Loader();
          }

          if (state is ProfileOwnerDataSuccess) {
            return _buildProfileContent(state.ownerData);
          }

          return _buildEmptyProfileContent();
        },
      ),
    );
  }

  Widget _buildProfileContent(OwnerData ownerData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(ownerData),
          _buildMenuOptions(context),
        ],
      ),
    );
  }

  Widget _buildEmptyProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmptyProfileHeader(),
          _buildMenuOptions(context),
        ],
      ),
    );
  }

  Widget _buildEmptyProfileHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 40, color: Colors.black54),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Loading user...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please wait",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(OwnerData ownerData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            backgroundImage: ownerData.profileUrl?.isNotEmpty ?? false
                ? NetworkImage(ownerData.profileUrl!)
                : null,
            child: ownerData.profileUrl?.isEmpty ?? true
                ? const Icon(Icons.person, size: 40, color: Colors.black54)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ownerData.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.customerEditProfile,
                  ).then((value) {
                    if (value == true) {
                      _loadUserData(ownerData.id);
                    }
                  });
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

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.account_circle, "Revenue", onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.ownerRevenue,
          );
        }),
        _buildMenuItem(Icons.support_agent, "Contact Support", onTap: () {
          Navigator.pushNamed(context, AppRoutes.customerHelp);
        }),
        _buildMenuItem(Icons.logout, "Log out", onTap: () {
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

  Widget _buildMenuItem(IconData icon, String title,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
