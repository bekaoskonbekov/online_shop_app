import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionName;

  BaseRepository(this.firestore, this.collectionName);

  Future<T> create(T item) async {
    try {
      final docRef = firestore.collection(collectionName).doc();
      final data = (item as dynamic).toMap();
      data['id'] = docRef.id;
      await docRef.set(data);
      return (item as dynamic).copyWith(id: docRef.id);
    } catch (e) {
      throw handleException('Объект түзүүдө ката кетти', e);
    }
  }
 Future<List<T>> getByField(String field, dynamic value) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where(field, isEqualTo: value)
          .get();
      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw handleException('$field боюнча объекттерди алууда ката кетти', e);
    }
  }

  Future<void> addToArray(String docId, String field, dynamic value) async {
    try {
      await firestore.collection(collectionName).doc(docId).update({
        field: FieldValue.arrayUnion([value])
      });
    } catch (e) {
      throw handleException('Массивге элемент кошууда ката кетти', e);
    }
  }
  Future<void> initialize(List<Map<String, dynamic>> items) async {
    try {
      final batch = firestore.batch();
      for (var item in items) {
        final docRef = firestore.collection(collectionName).doc();
        batch.set(docRef, {...item, 'id': docRef.id});
      }
      await batch.commit();
    } catch (e) {
      throw handleException('Объекттерди инициализациялоодо ката кетти', e);
    }
  }

  Future<List<T>> getAll() async {
    try {
      final querySnapshot = await firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw handleException('Бардык объекттерди алууда ката кетти', e);
    }
  }

  Future<T?> getById(String id) async {
    try {
      final docSnapshot = await firestore.collection(collectionName).doc(id).get();
      return docSnapshot.exists ? fromFirestore(docSnapshot) : null;
    } catch (e) {
      throw handleException('ID боюнча объектти алууда ката кетти', e);
    }
  }

  Future<List<T>> getByProductType(String productType) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where('productType', isEqualTo: productType)
          .get();
      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw handleException('Продукт түрү боюнча объекттерди алууда ката кетти', e);
    }
  }
  Future<T> update(T item) async {
    try {
      final data = (item as dynamic).toMap();
      final docRef = firestore.collection(collectionName).doc(data['id']);
      await docRef.update(data);
      return item;
    } catch (e) {
      throw handleException('Объектти жаңыртууда ката кетти', e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw handleException('Объектти өчүрүүдө ката кетти', e);
    }
  }

  T fromFirestore(DocumentSnapshot doc);

  Exception handleException(String message, dynamic error) {
    print('$message: $error');
    return Exception('$message: $error');
  }
}