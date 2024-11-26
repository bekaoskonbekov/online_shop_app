import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String id;
  final String name;
  final List<SubLocationModel> subLocations;

  LocationModel({
    required this.id,
    required this.name,
    this.subLocations = const [],
  });

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LocationModel(
      id: doc.id,
      name: data['name'] ?? '',
      subLocations: (data['subLocations'] as List<dynamic>?)
              ?.map((sub) => SubLocationModel.fromMap(sub as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subLocations: (map['subLocations'] as List<dynamic>?)
              ?.map((sub) => SubLocationModel.fromMap(sub as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subLocations': subLocations.map((sub) => sub.toMap()).toList(),
    };
  }
}

class SubLocationModel {
  final String id;
  final String name;

  SubLocationModel({
    required this.id,
    required this.name,
  });

  factory SubLocationModel.fromMap(Map<String, dynamic> map) {
    return SubLocationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}