import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:yaladrive/core/common/widgets/loader.dart';
import 'package:yaladrive/core/routes/app_routes.dart';
import 'package:yaladrive/core/utils/show_snackerbar.dart';
import 'package:yaladrive/core/common/entities/car_details.dart';
import 'package:yaladrive/features/booking/domain/entites/booking.dart';
import 'package:yaladrive/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:yaladrive/features/register/presentation/bloc/register_bloc.dart';
import 'package:yaladrive/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class GetCars extends StatefulWidget {
  const GetCars({super.key});

  @override
  State<GetCars> createState() => _GetCarsState();
}

class _GetCarsState extends State<GetCars> {
  List<CarDetails> cars = [];
  String? location;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _loadBookings(userState.user.id);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && location == null) {
      location = args['location'];
      if (location != null) {
        _loadCars(location!);
      }
    }
  }

  void _loadCars(String location) {
    context
        .read<RegisterBloc>()
        .add(RegisterGetCarByLocation(location: location));
  }

  void _loadBookings(String userId) {
    context.read<BookingBloc>().add(ShowBookingForUserEvent(userId: userId));
  }

  bool _isCarBooked(String carNumber, bookings) {
    final DateTime now = DateTime.now();
    return bookings.any((booking) =>
        booking.carNo == carNumber &&
        now.isAfter(booking.startDate) ||
        now.isBefore(booking.endDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Car'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingSuccessListBooking) {
                setState(() {
                  bookings = state.bookings;
                  for (var car in cars) {
                    car.isBooked = _isCarBooked(car.carNumber, bookings);
                  }
                });
              }
            },
          ),
        ],
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailure) {
              showSnackerbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              return Loader();
            }

            if (state is RegisterGetListCarsSuccess) {
              cars = state.cars;
            }

            if (cars.isEmpty) {
              return const Center(child: Text('No cars available.'));
            }

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                bool isBooked = car.isBooked;

                print('isBooked: $isBooked');
                return GestureDetector(
                  onTap: () async {
                    final box = serviceLocator<Box>();

                    Map<String, dynamic> carDetailsToMap(CarDetails car) {
                      return {
                        'ownerId': car.ownerId,
                        'location': car.location,
                        'carName': car.carName,
                        'carNumber': car.carNumber,
                        'isBooked': car.isBooked,
                        'pricePerDay': car.pricePerDay,
                        'carUrl': car.carUrl,
                      };
                    }

                    CarDetails mapToCarDetails(Map<String, dynamic> map) {
                      return CarDetails(
                        ownerId: map['ownerId'],
                        location: map['location'],
                        carName: map['carName'],
                        carNumber: map['carNumber'],
                        isBooked: map['isBooked'],
                        pricePerDay: map['pricePerDay'],
                        carUrl: map['carUrl'],
                      );
                    }

                    final existingCars = (box.get('recently_viewed_cars',
                            defaultValue: []) as List)
                        .map((item) =>
                            mapToCarDetails(Map<String, dynamic>.from(item)))
                        .toList();

                    if (!existingCars.any((existingCar) =>
                        existingCar.carName == car.carName &&
                        existingCar.carUrl == car.carUrl &&
                        existingCar.pricePerDay == car.pricePerDay &&
                        existingCar.location == car.location)) {
                      existingCars.add(car);
                      await box.put('recently_viewed_cars',
                          existingCars.map(carDetailsToMap).toList());
                    }

                    if (!context.mounted) return;

                    Navigator.pushNamed(
                      context,
                      AppRoutes.carDetails,
                      arguments: {
                        'car': car,
                        'isBooked': isBooked,
                      },
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15.0)),
                          child: Image.network(
                            car.carUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.carName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(car.location,
                                  style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${car.pricePerDay}TND/day',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    isBooked
                                        ? Icons.lock
                                        : Icons.directions_car,
                                    color: isBooked ? Colors.red : Colors.green,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
