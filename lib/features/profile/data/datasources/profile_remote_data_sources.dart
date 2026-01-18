import 'dart:io';

import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/customer_data_model.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/owner_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class ProfileRemoteDataSources {
  Future<CustomerDataModel> getCustomerData({
    required String userId,
  });

  Future<OwnerDataModel> getOwnerData({
    required String ownerId,
  });

  Future<void> editUserData({
    required String name,
    required File? profileImage,
    required String userId,
  });

  Future<void> checkCarBooked({
    required String carNo,
    required bool isBooked,
  });
}

class ProfileRemoteDataSourcesImpl implements ProfileRemoteDataSources {
  final FirebaseFirestore fireStore;
  final FirebaseStorage fireStorage;

  static const String _usersCollection = 'users';
  static const String _carsCollection = 'cars';
  static const String _profileImagesPath = 'profile_images';

  ProfileRemoteDataSourcesImpl(
    this.fireStore,
    this.fireStorage,
  );

  @override
  Future<void> editUserData({
    required String name,
    required File? profileImage,
    required String userId,
  }) async {
    try {
      final Map<String, dynamic> updateData = {'name': name};

      if (profileImage != null) {
        final storageRef =
            fireStorage.ref().child('$_profileImagesPath/$userId.jpg');
        await storageRef.putFile(profileImage);
        final imageUrl = await storageRef.getDownloadURL();
        updateData['profileImageUrl'] = imageUrl;
      }

      await fireStore
          .collection(_usersCollection)
          .doc(userId)
          .update(updateData);
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CustomerDataModel> getCustomerData({
    required String userId,
  }) async {
    try {
      final userDoc =
          await fireStore.collection(_usersCollection).doc(userId).get();

      if (!userDoc.exists) {
        throw ServerException('User not found');
      }

      final userData = userDoc.data();
      if (userData == null) {
        throw ServerException('User data is null');
      }

      final user = CustomerDataModel.fromJson({
        'name': userData['name'] ?? '',
        'profileUrl': userData['profileImageUrl'] ?? '',
        'id': userId,
      });

      return user;
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<OwnerDataModel> getOwnerData({
    required String ownerId,
  }) async {
    try {
      final ownerDoc =
          await fireStore.collection(_usersCollection).doc(ownerId).get();

      if (!ownerDoc.exists) {
        throw ServerException('User not found');
      }

      final userData = ownerDoc.data();
      if (userData == null) {
        throw ServerException('User data is null');
      }

      final carsSnapshot = await fireStore
          .collection(_carsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final List<Map<String, dynamic>> carsData =
          carsSnapshot.docs.map((doc) => doc.data()).toList();

      final owner = OwnerDataModel.fromJson({
        'name': userData['name'] ?? '',
        'profileUrl': userData['profileImageUrl'] ?? '',
        'id': ownerId,
        'noOfCars': carsData.length,
        'cars': carsData,
      });

      return owner;
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> checkCarBooked({
    required String carNo,
    required bool isBooked,
  }) async {
    try {
      final carDoc =
          await fireStore.collection(_carsCollection).doc(carNo).get();

      if (carDoc.exists) {
        await carDoc.reference.update({'isBooked': isBooked});
      } else {
        throw Exception('Car not found');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
