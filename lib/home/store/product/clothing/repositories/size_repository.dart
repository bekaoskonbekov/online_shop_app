import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';
class SizeRepository extends BaseRepository<SizeModel> {
  SizeRepository({FirebaseFirestore? firestore})
      : super(firestore ?? FirebaseFirestore.instance, 'sizes');

  @override
  SizeModel fromFirestore(DocumentSnapshot doc) {
    return SizeModel.fromFirestore(doc);
  }

  Future<void> updateSizesForProduct(String productId, List<SizeModel> sizes) async {
    try {
      final batch = firestore.batch();
      for (var size in sizes) {
        final sizeRef = firestore.collection(collectionName).doc(size.sizeId);
        batch.set(sizeRef, size.toMap(), SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      throw handleException('Продукт үчүн өлчөмдөрдү жаңыртууда ката кетти', e);
    }
  }

  Future<void> initializeSizes(List<Map<String, dynamic>> sizes) async {
    try {
      await initialize(sizes);
    } catch (e) {
      throw handleException('Өлчөмдөрдү инициализациялоодо ката кетти', e);
    }
  }
  Future<SizeModel?> getSizeById(String sizeId) async {
    try {
      return getById(sizeId);
    } catch (e) {
      throw handleException('ID боюнча өлчөмдү алууда ката кетти', e);
    }
  }

  Future<List<SizeModel>> getSizesByCategory(String categoryType) async {
    try {
      return getByField('categoryType', categoryType);
    } catch (e) {
      throw handleException('Категория боюнча өлчөмдөрдү алууда ката кетти', e);
    }
  }

  Future<void> addProductToSize(String productId, String sizeId) async {
    try {
      await addToArray(sizeId, 'productIds', productId);
    } catch (e) {
      throw handleException('Өлчөмгө продуктту кошууда ката кетти', e);
    }
  }
}
