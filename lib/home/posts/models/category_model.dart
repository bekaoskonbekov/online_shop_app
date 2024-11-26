import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final List<SubCategoryModel> subcategories; 

  CategoryModel({
    required this.id,
    required this.name,
    this.subcategories = const [],
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      subcategories: (data['subcategories'] as List<dynamic>?)
              ?.map((sub) => SubCategoryModel.fromMap(sub as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subcategories: (map['subcategories'] as List<dynamic>?)
              ?.map((sub) => SubCategoryModel.fromMap(sub as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subcategories': subcategories.map((sub) => sub.toMap()).toList(),
    };
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final List<SubCategoryModel> subcategories;

  SubCategoryModel({
    required this.id,
    required this.name,
    this.subcategories = const [],
  });

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subcategories: (map['subcategories'] as List<dynamic>?)
              ?.map((sub) => SubCategoryModel.fromMap(sub as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subcategories': subcategories.map((sub) => sub.toMap()).toList(),
    };
  }
}
