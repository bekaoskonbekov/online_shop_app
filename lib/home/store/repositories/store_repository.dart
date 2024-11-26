import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore;
  StoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  Future<StoreModel?> createStore({
    required String userId,
    required String storeBannerUrl,
    required String storeName,
    required String storeDescription,
    required String contactPhone,
    required String address,
    required Map<String, String> businessHours,
    required List<String> socialMediaLinks,
  }) async {
    try {
      final existingStoreQuery = await _firestore
          .collection('stores')
          .where('storeName', isEqualTo: storeName)
          .limit(1)
          .get();
      if (existingStoreQuery.docs.isNotEmpty) {
        throw Exception("Store name already exists.");
      }
      final docRef = await _firestore.collection('stores').add({
        'userId': userId,
        'storeBannerUrl': storeBannerUrl,
        'storeName': storeName,
        'storeDescription': storeDescription,
        'contactPhone': contactPhone,
        'address': address,
        'timestamp': FieldValue.serverTimestamp(),
        'isActive': true,
        'followersCount': 0,
        'isVerified': false,
        'rating': 0.0,
        'socialMediaLinks': socialMediaLinks,
        'products': [],
        'businessHours': businessHours,
      });
      final doc = await docRef.get();
      return StoreModel.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateStore(String storeId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('stores').doc(storeId).update(updates);
    } catch (e) {
      throw Exception('Failed to update store: $e');
    }
  }
  Future<StoreModel?> getStore(String storeId) async {
    try {
      final doc = await _firestore.collection('stores').doc(storeId).get();
      if (doc.exists) {
        return StoreModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get store by ID: $e');
    }
  }

  Future<StoreModel?> getStoreByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('stores')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return StoreModel.fromFirestore(querySnapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get store by user ID: $e');
    }
  }
}