import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  final String materialId;
  final String name;
  final String categoryType;
  final List<String> productIds;

  MaterialModel({
    required this.materialId,
    required this.name,
    required this.categoryType,
    this.productIds = const [],
  });

  factory MaterialModel.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }
      return MaterialModel(
        materialId: doc.id,
        name: data['name'] as String? ?? '',
        categoryType: data['categoryType'] as String? ?? '',
        productIds: List<String>.from(data['productIds'] ?? []),
      );
    } catch (e) {
      print('Error in MaterialModel.fromFirestore: $e');
      rethrow;
    }
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      materialId: map['materialId'] ?? '',
      name: map['name'] ?? '',
      categoryType: map['categoryType'] ?? '',
      productIds: List<String>.from(map['productIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryType': categoryType,
      'productIds': productIds,
    };
  }

  MaterialModel copyWith({
    String? materialId,
    String? name,
    String? categoryType,
    List<String>? productIds,
  }) {
    return MaterialModel(
      materialId: materialId ?? this.materialId,
      name: name ?? this.name,
      categoryType: categoryType ?? this.categoryType,
      productIds: productIds ?? this.productIds,
    );
  }

  @override
  String toString() {
    return 'MaterialModel(materialId: $materialId, name: $name, categoryType: $categoryType, productIds: $productIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialModel &&
        other.materialId == materialId &&
        other.name == name &&
        other.categoryType == categoryType &&
        listEquals(other.productIds, productIds);
  }

  @override
  int get hashCode {
    return materialId.hashCode ^
        name.hashCode ^
        categoryType.hashCode ^
        productIds.hashCode;
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