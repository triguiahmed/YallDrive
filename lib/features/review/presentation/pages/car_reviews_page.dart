import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart' as utils;
import 'package:yaladrive/features/review/domain/entities/review.dart';
import 'package:yaladrive/features/review/presentation/bloc/review_bloc.dart';
import 'package:yaladrive/features/review/presentation/widgets/add_review_dialog.dart';
import 'package:yaladrive/features/review/presentation/widgets/review_card.dart';
import 'package:yaladrive/features/review/presentation/widgets/star_rating.dart';
import 'package:yaladrive/init_dependencies.dart';

class CarReviewsPage extends StatefulWidget {
  final String carNo;
  final String carName;
  final String currentUserId;

  const CarReviewsPage({
    super.key,
    required this.carNo,
    required this.carName,
    required this.currentUserId,
  });

  @override
  State<CarReviewsPage> createState() => _CarReviewsPageState();
}

class _CarReviewsPageState extends State<CarReviewsPage> {
  List<Review> _reviews = [];
  double _averageRating = 0.0;
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    context.read<ReviewBloc>().add(
          GetReviewsForCarEvent(carNo: widget.carNo),
        );
  }

  Future<void> _loadUserNames(List<Review> reviews) async {
    final firestore = serviceLocator<FirebaseFirestore>();
    for (final review in reviews) {
      if (!_userNames.containsKey(review.userId)) {
        try {
          final userDoc =
              await firestore.collection('users').doc(review.userId).get();
          if (userDoc.exists) {
            _userNames[review.userId] = userDoc.data()?['name'] ?? 'Anonymous';
          }
        } catch (e) {
          _userNames[review.userId] = 'Anonymous';
        }
      }
    }
    if (mounted) setState(() {});
  }

  void _calculateAverageRating() {
    if (_reviews.isEmpty) {
      _averageRating = 0.0;
      return;
    }
    final total = _reviews.fold<int>(0, (sum, r) => sum + r.rating);
    _averageRating = total / _reviews.length;
  }

  bool get _hasUserReviewed =>
      _reviews.any((r) => r.userId == widget.currentUserId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.carName}'),
        backgroundColor: AppPallete.gradient1,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            showSnackBar(context, state.message);
          } else if (state is ReviewsLoaded) {
            _reviews = state.reviews;
            _calculateAverageRating();
            _loadUserNames(state.reviews);
          } else if (state is ReviewCreated) {
            showSnackBar(context, 'Review added successfully!');
            _loadReviews();
          } else if (state is ReviewUpdated) {
            showSnackBar(context, 'Review updated successfully!');
            _loadReviews();
          } else if (state is ReviewDeleted) {
            showSnackBar(context, 'Review deleted successfully!');
            _loadReviews();
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading && _reviews.isEmpty) {
            return const Loader();
          }

          return RefreshIndicator(
            onRefresh: () async => _loadReviews(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                if (_reviews.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No reviews yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Be the first to review this car!',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = _reviews[index];
                        return ReviewCard(
                          review: review,
                          userName: _userNames[review.userId],
                          isOwner: review.userId == widget.currentUserId,
                          onEdit: () => _showEditReviewDialog(review),
                          onDelete: () => _confirmDeleteReview(review),
                        );
                      },
                      childCount: _reviews.length,
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: !_hasUserReviewed
          ? FloatingActionButton.extended(
              onPressed: _showAddReviewDialog,
              backgroundColor: AppPallete.gradient1,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.rate_review),
              label: const Text('Add Review'),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.gradient1.withOpacity(0.1),
      ),
      child: Column(
        children: [
          AverageRatingDisplay(
            averageRating: _averageRating,
            totalReviews: _reviews.length,
          ),
          const SizedBox(height: 12),
          _buildRatingDistribution(),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution() {
    final distribution = List.generate(5, (index) {
      final rating = 5 - index;
      final count = _reviews.where((r) => r.rating == rating).length;
      final percentage = _reviews.isEmpty ? 0.0 : count / _reviews.length;
      return _RatingBar(rating: rating, percentage: percentage, count: count);
    });

    return Column(children: distribution);
  }

  void _showAddReviewDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddReviewDialog(),
    );

    if (result != null && mounted) {
      context.read<ReviewBloc>().add(
            CreateReviewEvent(
              carNo: widget.carNo,
              userId: widget.currentUserId,
              rating: result['rating'] as int,
              comment: result['comment'] as String,
            ),
          );
    }
  }

  void _showEditReviewDialog(Review review) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddReviewDialog(
        isEditing: true,
        initialRating: review.rating,
        initialComment: review.comment,
      ),
    );

    if (result != null && mounted) {
      context.read<ReviewBloc>().add(
            UpdateReviewEvent(
              reviewId: review.id,
              userId: widget.currentUserId,
              rating: result['rating'] as int,
              comment: result['comment'] as String,
            ),
          );
    }
  }

  void _confirmDeleteReview(Review review) {
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewBloc>().add(
                    DeleteReviewEvent(
                      reviewId: review.id,
                      userId: widget.currentUserId,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int rating;
  final double percentage;
  final int count;

  const _RatingBar({
    required this.rating,
    required this.percentage,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$rating'),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
