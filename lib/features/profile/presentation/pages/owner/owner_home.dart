import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/routes/app_routes.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:yaladrive/features/profile/presentation/pages/owner/owner.dart';
import 'package:yaladrive/features/profile/presentation/pages/scaffold_page.dart';
import 'package:yaladrive/features/review/presentation/bloc/review_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  int noOfCars = 0;

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(
            ProfileGetOwnerCars(ownerId: userState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final dummyFeedbacks = [
      {
        'text': 'Great service! The car was in excellent condition.',
        'author': 'Ahmed M.',
        'rating': 5,
      },
      {
        'text': 'Smooth booking process and friendly staff.',
        'author': 'Sara K.',
        'rating': 5,
      },
      {
        'text': 'Had a minor issue, but support resolved it quickly.',
        'author': 'Mohamed A.',
        'rating': 4,
      },
      {
        'text': 'Highly recommend this platform for car rentals.',
        'author': 'Leila B.',
        'rating': 5,
      },
    ];*/

    return ScaffoldPage(
      title: 'Welcome to YallaDrive',
      currentIndex: 0,
      bottomNavItems: Owner.bottomNavbarItems,
      routes: Owner.routes,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            showSnackerbar(context, state.message);
          }
           if (state is ProfileOwnerCarsSuccess) {
            final carNos = state.cars.map((c) => c.carNumber).toList();
            context
                .read<ReviewBloc>()
                .add(GetReviewsForCarsEvent(carNos: carNos));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Loader();
          }

          if (state is ProfileOwnerCarsSuccess) {
            noOfCars = state.cars.length;
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPallete.gradient3.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stats Card with Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppPallete.gradient3,
                          AppPallete.gradient2,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.gradient3.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            '$noOfCars',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Registered Vehicles',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Register New Car Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppPallete.gradient1,
                          AppPallete.gradient2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.gradient2.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.registerForm,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Register New Vehicle',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  
                  // Feedbacks Section Header
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppPallete.gradient3,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Customer Feedbacks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.gradient3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Feedbacks List
                  Expanded(
                    child: BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        if (state is ReviewLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ReviewError) {
                          return Center(child: Text(state.message));
                        } else if (state is ReviewsLoaded) {
                          if (state.reviews.isEmpty) {
                            return const Center(child: Text('No reviews yet.'));
                          }
                          return ListView.builder(
                            itemCount: state.reviews.length,
                            itemBuilder: (context, index) {
                              final review = state.reviews[index];
                              // Use generic "User" as name since we don't have it in Review entity
                              const authorName = "YallaDrive User";

                              return Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppPallete.gradient3
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPallete.gradient3
                                          .withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: AppPallete
                                                .gradient3
                                                .withOpacity(0.1),
                                            child: Text(
                                              authorName[0],
                                              style: TextStyle(
                                                color: AppPallete.gradient3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  authorName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (starIndex) => Icon(
                                                      starIndex < review.rating
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        review.comment,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}