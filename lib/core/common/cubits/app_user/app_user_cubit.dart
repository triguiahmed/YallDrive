import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:car_rental_app_clean_arch/core/common/entities/user.dart';
import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late final StreamSubscription<auth.User?> _authSubscription;

  AppUserCubit(this._auth, this._firestore) : super(AppUserInitial()) {
    _authSubscription =
        _auth.authStateChanges().listen((auth.User? user) async {
      if (user == null) {
        emit(AppUserInitial());
      } else {
        await _loadUser(user);
      }
    });
  }

  Future<void> _loadUser(auth.User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      User appUser = User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? data['name'] ?? '',
        role: data['role'] ?? 'CUSTOMER',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        fcmtoken: data['fcmtoken'] ?? '',
      );
      emit(AppUserLoggedIn(appUser));
    } else {
      emit(AppUserInitial());
    }
  }

  void updateUser(User user) {
    emit(AppUserLoggedIn(user));
  }

  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _loadUser(user);
    }
  }

  Future<void> changeRole(String newRole) async {
    final currentState = state;
    if (currentState is AppUserLoggedIn) {
      final userId = currentState.user.id;
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .update({'role': newRole});

        final updatedUser = currentState.user.copyWith(role: newRole);
        emit(AppUserLoggedIn(updatedUser));
      } catch (e) {
        throw ServerException("Error updating role: ${e.toString()}");
      }
    } else {
      throw ServerException("No logged-in user found");
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<void> logOut() async {
    await _auth.signOut();
    var box = await Hive.openBox('recently_viewed_cars');
    await box.clear();
  }
}
