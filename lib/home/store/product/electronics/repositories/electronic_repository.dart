import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/product/electronics/models/electronic_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class ElectronicsRepository extends BaseRepository<ElectronicsModel> {
  ElectronicsRepository(FirebaseFirestore firestore)
      : super(firestore, 'products');

  @override
  ElectronicsModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElectronicsModel.fromMap({...data, 'electronicsId': doc.id});
  }

  Future<ElectronicsModel> createElectronics(ElectronicsModel electronics) async {
    try {
      final docRef = electronics.params.productId!.isEmpty
          ? firestore.collection(collectionName).doc()
          : firestore.collection(collectionName).doc(electronics.params.productId);
      
      final updatedElectronics = electronics.copyWith(
        electronicsId: docRef.id,
      );
      
      await docRef.set(updatedElectronics.toMap(), SetOptions(merge: true));
      
      return updatedElectronics;
    } catch (e) {
      throw handleException('Электрониканы түзүүдө же жаңыртууда ката кетти', e);
    }
  }

  Future<List<ElectronicsModel>> getElectronicsByType(String type) async {
    try {
      return getByField('category.categoryType', type);
    } catch (e) {
      throw handleException('Түрү боюнча электроникаларды алууда ката кетти', e);
    }
  }

  Future<ElectronicsModel?> getElectronicsById(String id) async {
    return getById(id);
  }
}