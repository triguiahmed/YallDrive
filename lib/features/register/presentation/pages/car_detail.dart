import 'package:yaladrive/core/routes/app_routes.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/common/entities/car_details.dart';
import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:yaladrive/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/presentation/bloc/review_bloc.dart';
import 'package:yaladrive/features/review/presentation/widgets/star_rating.dart';
import 'package:yaladrive/features/review/presentation/widgets/review_card.dart';
import 'package:yaladrive/features/review/presentation/widgets/add_review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarDetail extends StatefulWidget {
  const CarDetail({super.key});

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  String? _currentUserId;
  CarDetails? _car;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['car'] != null) {
      _car = args['car'] as CarDetails;
      _loadData();
    }
  }

  void _loadData() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _currentUserId = userState.user.id;
      
      // Check if car is favorited
      context.read<FavoritesBloc>().add(
            CheckIsFavoritedEvent(
              userId: _currentUserId!,
              carNo: _car!.carNumber,
            ),
          );
    }
    
    // Load reviews for this car
    context.read<ReviewBloc>().add(
          GetReviewsForCarEvent(carNo: _car!.carNumber),
        );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['car'] == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Car Details')),
        body: Center(child: Text('No car details available')),
      );
    }

    final car = args['car'] as CarDetails;
    bool isBooked = args['isBooked'] as bool;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        actions: [
          if (_currentUserId != null)
            BlocFavoriteButton(
              carNo: car.carNumber,
              userId: _currentUserId!,
              size: 28,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                car.carUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.car_rental, size: 50)),
                ),
              ),
            ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    car.carName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isBooked ? Icons.close : Icons.check_circle,
                      color: isBooked ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isBooked ? 'Booked' : 'Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isBooked ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              'Car Number: ${car.carNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            Text(
              'Location: ${car.location}',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            Text(
              'Price per Day: ${car.pricePerDay.toStringAsFixed(2)}TND',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),

            Divider(),
            
            // Reviews Section
            _buildReviewsSection(car),
            
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bookingHome,
                      arguments: {
                        'car': car,
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.gradient1,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(CarDetails car) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (state is ReviewsLoaded && state.reviews.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${state.reviews.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                if (_currentUserId != null)
                  TextButton.icon(
                    onPressed: () => _showAddReviewDialog(car),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Review'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Average Rating
            if (state is ReviewsLoaded && state.reviews.isNotEmpty)
              Row(
                children: [
                  StarRating(
                    rating: _calculateAverageRating(state.reviews).toInt(),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateAverageRating(state.reviews).toStringAsFixed(1)} out of 5',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Reviews List
            if (state is ReviewLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is ReviewsLoaded)
              state.reviews.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No reviews yet',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_currentUserId != null)
                              TextButton(
                                onPressed: () => _showAddReviewDialog(car),
                                child: const Text('Be the first to review!'),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // Show first 3 reviews
                        ...state.reviews.take(3).map(
                              (review) => ReviewCard(
                                review: review,
                                onEdit: review.userId == _currentUserId
                                    ? () => _showEditReviewDialog(car, review)
                                    : null,
                                onDelete: review.userId == _currentUserId
                                    ? () => _deleteReview(review)
                                    : null,
                              ),
                            ),
                        if (state.reviews.length > 3)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      title: Text('Reviews for ${car.carName}'),
                                    ),
                                    body: ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: state.reviews.length,
                                      itemBuilder: (context, index) {
                                        final review = state.reviews[index];
                                        return ReviewCard(
                                          review: review,
                                          onEdit: review.userId == _currentUserId
                                              ? () => _showEditReviewDialog(car, review)
                                              : null,
                                          onDelete: review.userId == _currentUserId
                                              ? () => _deleteReview(review)
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text('See all ${state.reviews.length} reviews'),
                          ),
                      ],
                    )
            else if (state is ReviewError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load reviews',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (s, r) => s + r.rating);
    return sum / reviews.length;
  }

  void _showAddReviewDialog(CarDetails car) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        carNo: car.carNumber,
        userId: _currentUserId!,
        onReviewSubmitted: () {
          context.read<ReviewBloc>().add(
                GetReviewsForCarEvent(carNo: car.carNumber),
              );
        },
      ),
    );
  }

  void _showEditReviewDialog(CarDetails car, Review review) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        carNo: car.carNumber,
        userId: _currentUserId!,
        existingReview: review,
        onReviewSubmitted: () {
          context.read<ReviewBloc>().add(
                GetReviewsForCarEvent(carNo: car.carNumber),
              );
        },
      ),
    );
  }

  void _deleteReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewBloc>().add(
                    DeleteReviewEvent(
                      reviewId: review.id,
                      userId: _currentUserId!,
                    ),
                  );
              // Refresh reviews
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  context.read<ReviewBloc>().add(
                        GetReviewsForCarEvent(carNo: review.carNo),
                      );
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
