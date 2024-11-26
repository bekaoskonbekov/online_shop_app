import 'package:cloud_firestore/cloud_firestore.dart';

class ColorModel {
  final String colorId;
  final String name;
  final int colorValue;

  ColorModel({
    required this.colorId,
    required this.name,
    required this.colorValue,
  });

  factory ColorModel.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }
      return ColorModel(
        colorId: doc.id,
        name: data['name'] as String? ?? '',
        colorValue: data['colorValue'] as int? ?? 0,
      );
    } catch (e) {
      print('Error in ColorModel.fromFirestore: $e');
      rethrow;
    }
  }

  factory ColorModel.fromMap(Map<String, dynamic> map) {
    return ColorModel(
      colorId: map['colorId'] ?? '',
      name: map['name'] ?? '',
      colorValue: map['colorValue'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'colorValue': colorValue,
    };
  }

  ColorModel copyWith({
    String? colorId,
    String? name,
    int? colorValue,
    String? categoryType,
    List<String>? productIds,
  }) {
    return ColorModel(
      colorId: colorId ?? this.colorId,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  @override
  String toString() {
    return 'ColorModel(colorId: $colorId, name: $name, colorValue: $colorValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorModel &&
        other.colorId == colorId &&
        other.name == name &&
        other.colorValue == colorValue;
  }

  @override
  int get hashCode {
    return colorId.hashCode ^ name.hashCode ^ colorValue.hashCode;
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
