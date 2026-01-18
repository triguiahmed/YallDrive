import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore fireStore;
  final FirebaseMessaging fireMessaging;
  AuthRemoteDataSourceImpl(
    this.firebaseAuth,
    this.fireStore,
    this.fireMessaging,
  );

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) return null;

      final userDoc = await fireStore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) return null;

      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        return UserModel.fromJson({
          'id': user.uid,
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'role': userDoc.data()?['role'] ?? 'CUSTOMER',
          'createdAt': userDoc.data()?['createdAt'] ?? Timestamp.now(),
          'fcmtoken': userDoc.data()?['fcmtoken'] ?? '',
        });
      } else {
        throw ServerException('User is null');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();

        final String? fcmToken = await fireMessaging.getToken();

        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
          role: 'CUSTOMER',
          createdAt: DateTime.now(),
          fcmtoken: fcmToken!,
        );

        await fireStore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        return userModel;
      } else {
        throw ServerException('User is null');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
