import 'package:cloud_firestore/cloud_firestore.dart';

class OperatingSystemModel {
  final String osId;
  final String productType;
  final String name;
  final List<OSVersion> versions;
  final List<String> productIds;

  const OperatingSystemModel({
    required this.osId,
    required this.productType,
    required this.name,
    required this.versions,
    this.productIds = const [],
  });

  Map<String, dynamic> toMap() => {
    'osId': osId,
    'productType': productType,
    'name': name,
    'versions': versions.map((v) => v.toMap()).toList(),
    'productIds': productIds,
  };

  factory OperatingSystemModel.fromMap(Map<String, dynamic> map, String id) {
    return OperatingSystemModel(
      osId: map['osId'] as String? ?? id,
      productType: map['productType'] as String? ?? '',
      name: map['name'] as String? ?? '',
      versions: (map['versions'] as List<dynamic>?)
          ?.map((v) => OSVersion.fromMap(v as Map<String, dynamic>))
          .toList() ?? [],
      productIds: List<String>.from(map['productIds'] as List<dynamic>? ?? []),
    );
  }

  factory OperatingSystemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null for document ${doc.id}');
    }
    return OperatingSystemModel.fromMap(data, doc.id);
  }

  OperatingSystemModel copyWith({
    String? osId,
    String? productType,
    String? name,
    List<OSVersion>? versions,
    List<String>? productIds,
  }) => OperatingSystemModel(
    osId: osId ?? this.osId,
    productType: productType ?? this.productType,
    name: name ?? this.name,
    versions: versions ?? this.versions,
    productIds: productIds ?? this.productIds,
  );

  @override
  String toString() => 'OperatingSystemModel(osId: $osId, productType: $productType, name: $name, versions: $versions, productIds: $productIds)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatingSystemModel &&
          runtimeType == other.runtimeType &&
          osId == other.osId &&
          productType == other.productType &&
          name == other.name &&
          versions == other.versions &&
          productIds == other.productIds;

  @override
  int get hashCode => osId.hashCode ^ productType.hashCode ^ name.hashCode ^ versions.hashCode ^ productIds.hashCode;
}

class OSVersion {
  final String number;
  final int releaseDateYear;

  const OSVersion({required this.number, required this.releaseDateYear});

  Map<String, dynamic> toMap() => {
    'number': number,
    'releaseDateYear': releaseDateYear,
  };

  factory OSVersion.fromMap(Map<String, dynamic> map) => OSVersion(
    number: map['number'] as String? ?? '',
    releaseDateYear: map['releaseDateYear'] as int? ?? 0,
  );

  OSVersion copyWith({
    String? number,
    int? releaseDateYear,
  }) => OSVersion(
    number: number ?? this.number,
    releaseDateYear: releaseDateYear ?? this.releaseDateYear,
  );

  @override
  String toString() => 'OSVersion(number: $number, releaseDateYear: $releaseDateYear)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSVersion &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          releaseDateYear == other.releaseDateYear;

  @override
  int get hashCode => number.hashCode ^ releaseDateYear.hashCode;
}