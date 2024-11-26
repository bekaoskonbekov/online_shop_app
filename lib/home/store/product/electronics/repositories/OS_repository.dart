import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class OSRepository extends BaseRepository<OperatingSystemModel> {
  OSRepository(FirebaseFirestore firestore)
      : super(firestore, 'operating_systems');

  @override
  OperatingSystemModel fromFirestore(DocumentSnapshot doc) {
    return OperatingSystemModel.fromFirestore(doc);
  }

  Future<void> initializeOS(Map<String, List<Map<String, dynamic>>> osList) async {
    try {
      final batch = firestore.batch();
      for (var entry in osList.entries) {
        String productType = entry.key;
        for (var osData in entry.value) {
          final docRef = firestore.collection(collectionName).doc();
          List<Map<String, dynamic>> versions = List.generate(
            osData['versions'].length,
            (i) => {
              'number': osData['versions'][i].toString(),
              'releaseDateYear': osData['releaseDateYear'][i],
            },
          );
          batch.set(docRef, {
            'name': osData['name'],
            'versions': versions,
            'productType': productType,
            'productIds': [],
            'osId': docRef.id,
          });
        }
      }
      await batch.commit();
    } catch (e) {
      throw handleException('Операциялык системаларды инициализациялоодо ката кетти', e);
    }
  }
  Future<List<OperatingSystemModel>> getOSByProductType(String productType) async {
    return getByField('productType', productType);
  }
  Future<Map<String, List<OperatingSystemModel>>> getAllGroupedByProductType() async {
    try {
      final allOS = await getAll();
      final Map<String, List<OperatingSystemModel>> osMap = {};
      for (var os in allOS) {
        osMap.putIfAbsent(os.productType, () => []).add(os);
      }
      return osMap;
    } catch (e) {
      throw handleException('Операциялык системаларды топтоштурууда ката кетти', e);
    }
  }

  Future<void> addProductToOS(String productId, String osId) async {
    try {
      final osDoc = await firestore.collection(collectionName).doc(osId).get();
      final osData = osDoc.data() as Map<String, dynamic>;
      final List<String> productIds = List<String>.from(osData['productIds'] ?? []);
      if (!productIds.contains(productId)) {
        productIds.add(productId);
        await firestore.collection(collectionName).doc(osId).update({
          'productIds': productIds,
        });
      } 
    } catch (e) {
      throw handleException('ОСке продуктту кошууда ката кетти', e);
    }
  }
}