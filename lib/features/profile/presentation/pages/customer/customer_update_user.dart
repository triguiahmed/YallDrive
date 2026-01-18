import 'dart:io';

import 'package:car_rental_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:car_rental_app_clean_arch/core/utils/pick_image.dart';
import 'package:car_rental_app_clean_arch/core/utils/show_snackerbar.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app_clean_arch/core/common/widgets/loader.dart';
import 'package:car_rental_app_clean_arch/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _profileImage;

  void _load(userId) {
    context.read<ProfileBloc>().add(ProfileGetCustomerData(userId: userId));
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      return Center(child: Text("No user logged in"));
    }
    final user = userState.user;
    _load(user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            showSnackerbar(context, state.message);
          }
          if (state is ProfileUpdateSuccess) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Loader();
          }
          if (state is ProfileCustomerDataSuccess) {
            _nameController.text = state.customerData.name;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : (state.customerData.profileUrl != null
                              ? NetworkImage(state.customerData.profileUrl!)
                              : null),
                      child: _profileImage == null &&
                              state.customerData.profileUrl == null
                          ? Icon(Icons.person, size: 80, color: Colors.black54)
                          : null,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: Text('Change Profile Image'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                                ProfileUpdateUser(
                                  name: _nameController.text,
                                  profileImage: _profileImage,
                                  userId: user.id,
                                ),
                              );
                        }
                      },
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No user data'));
        },
      ),
    );
  }
}
