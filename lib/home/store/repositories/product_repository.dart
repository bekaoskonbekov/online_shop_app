
// product_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class ProductRepository extends BaseRepository<ProductModel> {
  ProductRepository(FirebaseFirestore firestore) : super(firestore, 'products');

  @override
  ProductModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromMap({...data, 'productId': doc.id});
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      return getByField('category.id', categoryId);
    } catch (e) {
      throw handleException('Категория боюнча продуктуларды алууда ката кетти', e);
    }
  }

  Future<List<ProductModel>> getNewProducts({int limit = 10}) async {
    try {
      final query = firestore.collection(collectionName)
          .orderBy('createdAt', descending: true)
          .limit(limit);
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw handleException('Жаңы продуктуларды алууда ката кетти', e);
    }
  }

  Future<List<ProductModel>> getPopularProducts({int limit = 10}) async {
    try {
      final query = firestore.collection(collectionName)
          .orderBy('likes', descending: true)
          .limit(limit);
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw handleException('Популярдуу продуктуларды алууда ката кетти', e);
    }
  }
}