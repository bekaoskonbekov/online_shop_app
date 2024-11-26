import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/product_category.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class CategoryRepository extends BaseRepository<ProductCategoryModel> {
  CategoryRepository(FirebaseFirestore firestore) : super(firestore, 'categories');

  @override
  ProductCategoryModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductCategoryModel.fromMap({...data, 'id': doc.id});
  }

  Future<List<ProductCategoryModel>> getCategories({
    String parentCategoryId = '',
    String? categoryType,
    DocumentSnapshot? startAfterDocument,
    int depth = 1,
  }) async {
    try {
      var query = firestore
          .collection(collectionName)
          .where('parentCategoryId', isEqualTo: parentCategoryId)
          .orderBy('name');
      
      if (categoryType != null) {
        query = query.where('categoryType', isEqualTo: categoryType);
      }
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }
      
      final querySnapshot = await query.get();
      List<ProductCategoryModel> categories = querySnapshot.docs.map(fromFirestore).toList();
      
      if (depth > 0) {
        await Future.wait(categories.map((category) => _loadSubcategories(category, depth - 1)));
      }
      
      return categories;
    } catch (e) {
      throw handleException('Failed to get categories', e);
    }
  }

  Future<void> _loadSubcategories(ProductCategoryModel category, int depth) async {
    if (depth < 0) return;
    final subcategories = await Future.wait(category.subcategoryIds.map((id) => getById(id)));
    category = category.copyWith(
      subcategoryIds: subcategories.whereType<ProductCategoryModel>().map((c) => c.id).toList(),
    );
  }

  Future<void> initializeCategories(List<Map<String, dynamic>> initialCategories) async {
    try {
      for (var category in initialCategories) {
        await _createCategoryWithSubcategories(category);
      }
    } catch (e) {
      throw handleException('Failed to initialize categories', e);
    }
  }

  Future<String> _createCategoryWithSubcategories(Map<String, dynamic> categoryData, {String parentId = ''}) async {
    try {
      final newCategory = ProductCategoryModel(
        id: '',
        name: categoryData['name'],
        parentCategoryId: parentId,
        categoryType: categoryData['categoryType'],
        productType: categoryData['productType'],
        image: categoryData['image'],
        subcategoryIds: [],
        productIds: [],
      );
      final createdCategory = await create(newCategory);

      if (parentId.isNotEmpty) {
        await _addSubcategoryToParent(parentId, createdCategory.id);
      }

      if (categoryData['subcategories'] != null) {
        for (var subCategory in categoryData['subcategories']) {
          String subCategoryId = await _createCategoryWithSubcategories(subCategory, parentId: createdCategory.id);
          await _addSubcategoryToParent(createdCategory.id, subCategoryId);
        }
      }
      return createdCategory.id;
    } catch (e) {
      throw handleException('Failed to create category: ${categoryData['name']}', e);
    }
  }

  Future<void> _addSubcategoryToParent(String parentId, String subcategoryId) async {
    await firestore.collection(collectionName).doc(parentId).update({
      'subcategoryIds': FieldValue.arrayUnion([subcategoryId])
    });
  }

  Future<void> addProductToCategory(String categoryId, String productId) async {
    try {
      await firestore.collection(collectionName).doc(categoryId).update({
        'productIds': FieldValue.arrayUnion([productId])
      });
    } catch (e) {
      throw handleException('Failed to add product to category', e);
    }
  }
}