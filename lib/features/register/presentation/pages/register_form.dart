import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/utils/location_service.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:car_rental_app_clean_arch/core/utils/pick_image.dart';
import 'package:car_rental_app_clean_arch/features/register/presentation/widgets/register_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  List<String> _suggestions = [];

  Future<void> _updateSuggestions(String input) async {
    final suggestions = await LocationService.fetchSuggestions(input);
    setState(() => _suggestions = suggestions);
  }

  final TextEditingController locationController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController pricePerDayController = TextEditingController();

  File? carImage;

  @override
  void dispose() {
    locationController.dispose();
    carNameController.dispose();
    carNumberController.dispose();
    pricePerDayController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        carImage = pickedImage;
      });
    }
  }

  Future<void> _updateUserRole(String userId, context) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'OWNER',
      });
    } catch (e) {
      showSnackerbar(context, 'Failed to update role: ${e.toString()}');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && carImage != null) {
      final userState = context.read<AppUserCubit>().state;
      if (userState is AppUserLoggedIn) {
        final price = double.tryParse(pricePerDayController.text.trim());
        if (price == null) {
          showSnackerbar(context, 'Enter a valid price per day');
          return;
        }

        // Update Firestore role before registering the car
        _updateUserRole(userState.user.id, context);

        // Register car
        context.read<RegisterBloc>().add(
              RegisterCar(
                location: locationController.text.trim(),
                carName: carNameController.text.trim(),
                carNumber: carNumberController.text.trim(),
                pricePerDay: price,
                carImage: carImage!,
                ownerId: userState.user.id,
              ),
            );
      } else {
        showSnackerbar(context, 'User is not logged in');
      }
    } else {
      showSnackerbar(context, 'Please fill all fields and select an image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Your Car')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            showSnackerbar(context, state.message);
          } else if (state is RegisterSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.ownerHome,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegisterField(
                      controller: locationController,
                      label: 'Location',
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Location' : null,
                      onChanged: _updateSuggestions,
                    ),
                    if (_suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.purple,
                              ),
                              title: Text(_suggestions[index]),
                              onTap: () {
                                setState(() {
                                  locationController.text = _suggestions[index];
                                  _suggestions.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    RegisterField(
                      controller: carNameController,
                      label: 'Car Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Enter car name' : null,
                    ),
                    const SizedBox(height: 10),
                    RegisterField(
                      controller: carNumberController,
                      label: 'Car Number',
                      validator: (value) =>
                          value!.isEmpty ? 'Enter car number' : null,
                    ),
                    const SizedBox(height: 10),
                    RegisterField(
                      controller: pricePerDayController,
                      label: 'Price Per Day',
                      inputType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter price per day' : null,
                    ),
                    const SizedBox(height: 20),
                    carImage != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                carImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
