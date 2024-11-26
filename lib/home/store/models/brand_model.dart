import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String brandId;
  final String name;
  final String categoryType;
  final List<String> productIds;
  final String? image;

  BrandModel({
    required this.brandId,
    required this.name,
    required this.categoryType,
    this.productIds = const [],
    this.image,
  });

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }
    return BrandModel(
      brandId: doc.id,
      name: data['name'] as String? ?? '',
      categoryType: data['categoryType'] as String? ?? '',
      productIds: List<String>.from(data['productIds'] ?? []),
      image: data['image'] as String?,
    );
  }
 factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      brandId: map['brandId'] ?? '',
      name: map['name'] ?? '',
      categoryType: map['categoryType'] ?? '',
      productIds: List<String>.from(map['productIds'] ?? []),
      image: map['image'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryType': categoryType,
      'productIds': productIds,
      'image': image,
    };
  }

  BrandModel copyWith({
    String? brandId,
    String? name,
    String? categoryType,
    List<String>? productIds,
    String? image,
  }) {
    return BrandModel(
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      categoryType: categoryType ?? this.categoryType,
      productIds: productIds ?? this.productIds,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'BrandModel(brandId: $brandId, name: $name, categoryType: $categoryType, productIds: $productIds, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrandModel &&
        other.brandId == brandId &&
        other.name == name &&
        other.categoryType == categoryType &&
        other.image == image &&
        listEquals(other.productIds, productIds);
  }

  @override
  int get hashCode {
    return brandId.hashCode ^
        name.hashCode ^
        categoryType.hashCode ^
        productIds.hashCode ^
        image.hashCode;
  }
}
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}