import 'package:yalladrive/core/error/exception.dart';
import 'package:yalladrive/features/profile/data/models/customer_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<CustomerDataModel> getUser(String userId) async {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  try {
    final userSnapshot = await fireStore.collection('users').doc(userId).get();

    if (!userSnapshot.exists) {
      throw ServerException("User not found");
    }

    final userData = userSnapshot.data();
    return CustomerDataModel.fromJson(userData!);
  } catch (e) {
    throw ServerException(e.toString());
  }
}