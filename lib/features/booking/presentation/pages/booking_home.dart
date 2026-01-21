import 'package:yalladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yalladrive/core/common/entities/car_details.dart';
import 'package:yalladrive/core/common/widgets/loader.dart';
import 'package:yalladrive/core/routes/app_routes.dart';
import 'package:yalladrive/core/theme/app_pallete.dart';
import 'package:yalladrive/core/utils/show_snackerbar.dart';
import 'package:yalladrive/features/booking/domain/entites/booking.dart';
import 'package:yalladrive/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingHome extends StatefulWidget {
  const BookingHome({super.key});

  @override
  State<BookingHome> createState() => _BookingHomeState();
}

class _BookingHomeState extends State<BookingHome> {
  late DateTime calendarMonth;
  DateTime? startDate;
  DateTime? endDate;
  CarDetails? car;
  double pricePerDay = 0.0;
  double totalPrice = 0.0;
  dynamic user;
  List<Booking> bookedDates = [];

  @override
  void initState() {
    super.initState();
    calendarMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['car'] != null) {
      setState(() {
        car = args['car'] as CarDetails;
        if (car?.pricePerDay != null) {
          pricePerDay = car!.pricePerDay.toDouble();
        }
      });
    }

    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      user = userState.user;
    }

    context.read<BookingBloc>().add(
          ShowBookingForCarEvent(
            carNo: car!.carNumber,
          ),
        );
  }

  void _calculateTotalPrice() {
    if (startDate != null && endDate != null) {
      final difference = endDate!.difference(startDate!).inDays + 1;
      setState(() {
        totalPrice = difference * pricePerDay;
      });
    } else {
      setState(() {
        totalPrice = 0;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      if (startDate == null || endDate != null) {
        startDate = selectedDay;
        endDate = null;
      } else if (selectedDay.isAfter(startDate!)) {
        endDate = selectedDay;
        _calculateTotalPrice();
      } else if (selectedDay.isBefore(startDate!)) {
        endDate = startDate;
        startDate = selectedDay;
        _calculateTotalPrice();
      } else {
        endDate = startDate;
        _calculateTotalPrice();
      }
    });
  }

  void _previousMonth() {
    setState(() {
      calendarMonth = DateTime(
        calendarMonth.year,
        calendarMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      calendarMonth = DateTime(
        calendarMonth.year,
        calendarMonth.month + 1,
      );
    });
  }

  void _confirmBooking() {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<BookingBloc>().add(
          BookCarEvent(
            userId: user.id,
            carNo: car!.carNumber,
            startDate: startDate!,
            endDate: endDate!,
            price: totalPrice,
            ownerId: car!.ownerId,
          ),
        );
  }

  bool _isDateBooked(DateTime date) {
    for (final booking in bookedDates) {
      if (!date.isBefore(booking.startDate) && !date.isAfter(booking.endDate)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Book a Car',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingFailure) {
            showSnackerbar(
              context,
              state.message,
            );
          } else if (state is BookingSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.customerBooking,
              (route) => false,
            );
          } else if (state is BookingSuccessListBooking) {
            setState(() {
              bookedDates = state.bookings;
            });
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car info card
                  _buildCarInfoCard(),

                  // Calendar navigation
                  _buildCalendarNavigation(),

                  // Calendar
                  _buildCalendar(),

                  const SizedBox(height: 20),

                  // Booking details
                  _buildBookingDetails(),

                  const SizedBox(height: 40),

                  // Book Now button
                  _buildBookNowButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarInfoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Car Image
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  car!.carUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Car Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car!.carName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  car!.location,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: ${pricePerDay.toStringAsFixed(1)}TND/day',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calendar navigation widget
  Widget _buildCalendarNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy').format(calendarMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }
  
  Widget _buildCalendar() {
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final firstDay = DateTime(calendarMonth.year, calendarMonth.month, 1);
    final firstDayOfWeek = firstDay.weekday % 7;
    final daysInMonth =
        DateUtils.getDaysInMonth(calendarMonth.year, calendarMonth.month);
    final rowCount = ((firstDayOfWeek + daysInMonth) / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => SizedBox(
                    width: 40,
                    child: Center(child: Text(day)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,),
          itemCount: rowCount * 7,
          itemBuilder: (context, index) {
            final int day = index - firstDayOfWeek + 1;
            final DateTime date =
                DateTime(calendarMonth.year, calendarMonth.month, day);
            final bool isCurrentMonth = day > 0 && day <= daysInMonth;

            // Check if date is booked
            final bool isBooked = isCurrentMonth && _isDateBooked(date);

            // Check past dates
            final bool isPastDate = date.isBefore(DateTime.now()) &&
                !isSameDay(date, DateTime.now());

            final bool isStartDate =
                startDate != null && isSameDay(date, startDate!);
            final bool isEndDate = endDate != null && isSameDay(date, endDate!);
            final bool isInRange = startDate != null &&
                endDate != null &&
                date.isAfter(startDate!) &&
                date.isBefore(endDate!);

            Color? bgColor;
            Color textColor =
                isPastDate || isBooked ? Colors.grey : Colors.black;

            if (isBooked) {
              bgColor = Colors.red.shade200; 
            }

            if (isStartDate || isEndDate) {
              bgColor = Colors.blue;
              textColor = Colors.white;
            } else if (isInRange) {
              bgColor = Colors.blue.withAlpha(80);
            }

            return GestureDetector(
              onTap: () {
                if (isCurrentMonth && !isPastDate && !isBooked) {
                  _onDaySelected(date);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isCurrentMonth ? day.toString() : '',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: isBooked ? FontWeight.bold : null),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Booking details widget
  Widget _buildBookingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date
        Row(
          children: [
            const Text(
              'Start Date: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              startDate != null
                  ? DateFormat('dd-MM-yyyy').format(startDate!)
                  : 'Select a date',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // End Date
        Row(
          children: [
            const Text(
              'End Date: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              endDate != null
                  ? DateFormat('dd-MM-yyyy').format(endDate!)
                  : 'Select a date',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Total Price
        Row(
          children: [
            const Text(
              'Total Price: ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${totalPrice.toStringAsFixed(1)}TND',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Book Now button widget
  Widget _buildBookNowButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed:
            startDate != null && endDate != null ? _confirmBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.gradient1,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Book Now',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppPallete.whiteColor,
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
