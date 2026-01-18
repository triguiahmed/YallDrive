import 'package:car_rental_app_clean_arch/core/error/exception.dart';
import 'package:car_rental_app_clean_arch/features/profile/data/models/owner_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<OwnerDataModel> getOwner(String ownerId) async {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  try {
    final userSnapshot = await fireStore.collection('users').doc(ownerId).get();

    if (!userSnapshot.exists) {
      throw ServerException("User not found");
    }

    final userData = userSnapshot.data();
    return OwnerDataModel.fromJson(userData!);
  } catch (e) {
    throw ServerException(e.toString());
  }
}