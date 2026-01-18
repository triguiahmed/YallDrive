import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/secrets/app_secrets.dart';
import 'package:car_rental_app_clean_arch/features/booking/domain/entites/booking.dart';
import 'package:car_rental_app_clean_arch/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  String? _animationFile;
  Booking? booking;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && booking == null) {
      booking = args['booking'];
    }
  }

  void navigate() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.customerBooking,
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openCheckout();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _isProcessing = true;
      _animationFile = Constants.successAnimation;
    });

    context.read<BookingBloc>().add(
          PaymentApproveEvent(
            bookingId: booking!.id,
            paymentStatus: 'Paid',
          ),
        );

    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isProcessing = false);
      navigate();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessing = true;
      _animationFile = Constants.failureAnimation;
    });

    context.read<BookingBloc>().add(
          PaymentApproveEvent(
            bookingId: booking!.id,
            paymentStatus: 'Failed',
          ),
        );

    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isProcessing = false);
      navigate();
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _openCheckout() {
    var options = {
      'key': AppSecrets.razorpayKEY,
      'amount': booking!.price * 100,
      'currency': 'INR',
      'name': 'Car Rental',
      'description': 'Car for rent',
      'prefill': {'contact': '9876543210', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      },
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
        'emi': true,
      },
      'display': {'popup': true},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed to initialize")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay Payment"),
      ),
      body: SafeArea(
        child: Center(
          child: _isProcessing
              ? (_animationFile != null
                  ? Lottie.asset(_animationFile!)
                  : const Loader())
              : const Loader(),
        ),
      ),
    );
  }
}
