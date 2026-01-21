import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';
import 'package:yaladrive/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:yaladrive/features/payment/presentation/widgets/payment_card.dart';
import 'package:yaladrive/init_dependencies.dart';

class PaymentHistoryPage extends StatefulWidget {
  final String userId;

  const PaymentHistoryPage({
    super.key,
    required this.userId,
  });

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Payment> _allPayments = [];
  Map<String, String> _bookingDetails = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPayments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPayments() {
    context.read<PaymentBloc>().add(
          GetPaymentsByUserEvent(userId: widget.userId),
        );
  }

  Future<void> _loadBookingDetails(List<Payment> payments) async {
    final firestore = serviceLocator<FirebaseFirestore>();

    for (final payment in payments) {
      if (!_bookingDetails.containsKey(payment.bookingId)) {
        try {
          final bookingDoc = await firestore
              .collection('bookings')
              .doc(payment.bookingId)
              .get();

          if (bookingDoc.exists) {
            final data = bookingDoc.data()!;
            final carNo = data['carNo'] ?? '';
            final startDate = DateTime.fromMillisecondsSinceEpoch(
              data['startDate'] ?? 0,
            );
            final endDate = DateTime.fromMillisecondsSinceEpoch(
              data['endDate'] ?? 0,
            );
            _bookingDetails[payment.bookingId] =
                'Car: $carNo | ${_formatDate(startDate)} - ${_formatDate(endDate)}';
          }
        } catch (e) {
          debugPrint('Error loading booking details: $e');
        }
      }
    }
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Payment> _filterPayments(PaymentStatus? status) {
    if (status == null) return _allPayments;
    return _allPayments.where((p) => p.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: AppPallete.gradient1,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Paid'),
            Tab(text: 'Failed'),
          ],
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) {
            showSnackBar(context, state.message);
          } else if (state is PaymentsLoaded) {
            _allPayments = state.payments;
            _loadBookingDetails(state.payments);
          } else if (state is PaymentUpdated) {
            showSnackBar(context, 'Payment status updated');
            _loadPayments();
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading && _allPayments.isEmpty) {
            return const Loader();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPaymentList(null),
              _buildPaymentList(PaymentStatus.pending),
              _buildPaymentList(PaymentStatus.paid),
              _buildPaymentList(PaymentStatus.failed),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentList(PaymentStatus? status) {
    final payments = _filterPayments(status);

    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == PaymentStatus.paid
                  ? Icons.check_circle_outline
                  : status == PaymentStatus.failed
                      ? Icons.error_outline
                      : status == PaymentStatus.pending
                          ? Icons.schedule
                          : Icons.payment,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              status == null
                  ? 'No payments yet'
                  : 'No ${status.value} payments',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadPayments(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return PaymentCard(
            payment: payment,
            bookingDetails: _bookingDetails[payment.bookingId],
            onTap: () => _showPaymentDetails(payment),
            onRetry: payment.status == PaymentStatus.failed
                ? () => _retryPayment(payment)
                : null,
          );
        },
      ),
    );
  }

  void _showPaymentDetails(Payment payment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildDetailRow('Payment ID', payment.id),
            _buildDetailRow('Booking ID', payment.bookingId),
            _buildDetailRow('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Method', payment.method.value.toUpperCase()),
            _buildDetailRow('Status', payment.status.value.toUpperCase()),
            _buildDetailRow('Created', _formatDateTime(payment.createdAt)),
            if (payment.paidAt != null)
              _buildDetailRow('Paid At', _formatDateTime(payment.paidAt!)),
            const SizedBox(height: 16),
            if (payment.status == PaymentStatus.pending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processPayment(payment);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.gradient1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Complete Payment'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _processPayment(Payment payment) {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Processing Payment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please wait...'),
          ],
        ),
      ),
    );

    // Simulate delay then update status
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close dialog
      context.read<PaymentBloc>().add(
            UpdatePaymentStatusEvent(
              paymentId: payment.id,
              userId: widget.userId,
              newStatus: PaymentStatus.paid,
            ),
          );
    });
  }

  void _retryPayment(Payment payment) {
    context.read<PaymentBloc>().add(
          UpdatePaymentStatusEvent(
            paymentId: payment.id,
            userId: widget.userId,
            newStatus: PaymentStatus.pending,
          ),
        );
  }
}
