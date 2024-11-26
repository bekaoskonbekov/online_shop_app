import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String id;
  final String name;
  final String categoryType;
  final String? parentCategoryId;
  final String? productType;
  final String? image;
  final List<String> productIds;
  final List<String> subcategoryIds;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.categoryType,
    this.parentCategoryId,
    this.productType,
    this.image,
    this.productIds = const [],
    this.subcategoryIds = const [],
  });

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      categoryType: map['categoryType'] ?? 'unknown',
      parentCategoryId: map['parentCategoryId'],
      productType: map['productType'],
      image: map['image'],
      productIds: List<String>.from(map['productIds'] ?? []),
      subcategoryIds: List<String>.from(map['subcategoryIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryType': categoryType,
      'parentCategoryId': parentCategoryId,
      'productType': productType,
      'image': image,
      'productIds': productIds,
      'subcategoryIds': subcategoryIds,
    };
  }


  factory ProductCategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductCategoryModel.fromMap(data);
  }


  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? categoryType,
    String? parentCategoryId,
    String? productType,
    String? image,
    List<String>? productIds,
    List<String>? subcategoryIds,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryType: categoryType ?? this.categoryType,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      productType: productType ?? this.productType,
      image: image ?? this.image,
      productIds: productIds ?? this.productIds,
      subcategoryIds: subcategoryIds ?? this.subcategoryIds,
    );
  }
}