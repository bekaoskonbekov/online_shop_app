import 'package:cloud_firestore/cloud_firestore.dart';

class CountryOfOriginModel {
  final String countryId;
  final String name;
  final String code;
  final List<String> productIds;
  final String? flagImage;

  CountryOfOriginModel({
    required this.countryId,
    required this.name,
    required this.code,
    this.productIds = const [],
    this.flagImage,
  });

  factory CountryOfOriginModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }
    return CountryOfOriginModel(
      countryId: doc.id,
      name: data['name'] as String? ?? '',
      code: data['code'] as String? ?? '',
      productIds: List<String>.from(data['productIds'] ?? []),
      flagImage: data['flagImage'] as String?,
    );
  }

  factory CountryOfOriginModel.fromMap(Map<String, dynamic> map) {
    return CountryOfOriginModel(
      countryId: map['countryId'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      productIds: List<String>.from(map['productIds'] ?? []),
      flagImage: map['flagImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'productIds': productIds,
      'flagImage': flagImage,
    };
  }

  CountryOfOriginModel copyWith({
    String? countryId,
    String? name,
    String? code,
    List<String>? productIds,
    String? flagImage,
  }) {
    return CountryOfOriginModel(
      countryId: countryId ?? this.countryId,
      name: name ?? this.name,
      code: code ?? this.code,
      productIds: productIds ?? this.productIds,
      flagImage: flagImage ?? this.flagImage,
    );
  }

  @override
  String toString() {
    return 'CountryOfOriginModel(countryId: $countryId, name: $name, code: $code, productIds: $productIds, flagImage: $flagImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryOfOriginModel &&
        other.countryId == countryId &&
        other.name == name &&
        other.code == code &&
        other.flagImage == flagImage &&
        listEquals(other.productIds, productIds);
  }

  @override
  int get hashCode {
    return countryId.hashCode ^
        name.hashCode ^
        code.hashCode ^
        productIds.hashCode ^
        flagImage.hashCode;
  }
}

// Көмөкчү функция
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}