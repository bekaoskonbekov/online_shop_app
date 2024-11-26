import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/material_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class MaterialRepository extends BaseRepository<MaterialModel> {
  MaterialRepository({FirebaseFirestore? firestore})
      : super(firestore ?? FirebaseFirestore.instance, 'materials');

  @override
  MaterialModel fromFirestore(DocumentSnapshot doc) {
    return MaterialModel.fromFirestore(doc);
  }

  Future<void> initializeMaterials(Map<String, List<String>> materialsByCategory) async {
    try {
      final batch = firestore.batch();
      materialsByCategory.forEach((categoryType, materials) {
        for (var materialName in materials) {
          final docRef = firestore.collection(collectionName).doc();
          batch.set(docRef, {
            'name': materialName,
            'categoryType': categoryType,
            'productIds': [],
          });
        }
      });
      await batch.commit();
    } catch (e) {
      throw handleException('Материалдарды инициализациялоодо ката кетти', e);
    }
  }

  Future<List<MaterialModel>> getAllMaterials() async {
    return getAll();
  }

  Future<MaterialModel?> getMaterialById(String materialId) async {
    return getById(materialId);
  }

  Future<List<MaterialModel>> getMaterialsByCategory(String categoryType) async {
    return getByField('categoryType', categoryType);
  }

  Future<void> addProductToMaterial(String productId, String materialId) async {
    return addToArray(materialId, 'productIds', productId);
  }
}
