import 'package:cloud_firestore/cloud_firestore.dart';

class SizeModel {
  final String sizeId;
  final String name;
  final Map<String, dynamic>? measurements;

  SizeModel({
    required this.sizeId,
    required this.name,
    this.measurements,
  });

  factory SizeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }
    return SizeModel(
      sizeId: doc.id,
      name: data['name'] as String? ?? '',
      measurements: data['measurements'] as Map<String, dynamic>?,
    );
  }

  factory SizeModel.fromMap(Map<String, dynamic> map) {
    return SizeModel(
      sizeId: map['sizeId'] ?? '',
      name: map['name'] ?? '',
      measurements: Map<String, dynamic>.from(map['measurements'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sizeId': sizeId,
      'name': name,
      'measurements': measurements,
    };
  }
}