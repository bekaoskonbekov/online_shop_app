import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class BrandRepository extends BaseRepository<BrandModel> {
  BrandRepository({FirebaseFirestore? firestore})
      : super(firestore ?? FirebaseFirestore.instance, 'brands');

  @override
  BrandModel fromFirestore(DocumentSnapshot doc) {
    return BrandModel.fromFirestore(doc);
  }

  Future<void> initializeBrands(Map<String, List<String>> brandsByCategory) async {
    try {
      final List<Map<String, dynamic>> brands = [];
      brandsByCategory.forEach((categoryType, brandNames) {
        for (var name in brandNames) {
          brands.add({
            'name': name,
            'categoryType': categoryType,
            'productIds': [],
          });
        }
      });
      await initialize(brands);
    } catch (e) {
      throw handleException('Бренддерди инициализациялоодо ката кетти', e);
    }
  }
  Future<List<BrandModel>> getBrandsByCategory(String categoryType) async {
    return getByField('categoryType', categoryType);
  }

   Future<void> addProductToBrand(String productId, String brandId) async {
    return addToArray(brandId, 'productIds', productId);
  }

  Future<void> addProductNoBrand(String productId) async {
    try {
      const noBrandId = 'no_brand';
      const noBrandName = 'No Brand';
      final noBrandDoc = await firestore.collection(collectionName).doc(noBrandId).get();
      if (!noBrandDoc.exists) {
        await firestore.collection(collectionName).doc(noBrandId).set({
          'name': noBrandName,
          'categoryType': 'all', 
          'productIds': [productId],
        });
      } else {
        await addProductToBrand(productId, noBrandId);
      }
    } catch (e) {
      throw handleException('Брендсиз продуктту кошууда ката кетти', e);
    }
  }
}

