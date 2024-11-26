import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/material_model.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/models/product_category.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';

class ElectronicsModel extends ProductModel {
  final String electronicsId;
  final String productType;
  final OperatingSystemModel operatingSystem;

  ElectronicsModel({
    required ProductParams params,
    required this.electronicsId,
    required this.productType,
    required this.operatingSystem,
  }) : super(params: params);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'electronicsId': electronicsId,
      'productType': productType,
      'operatingSystem': operatingSystem.toMap(),
      'categoryType': 'electronics',
    };
  }

  factory ElectronicsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElectronicsModel.fromMap({...data, 'productId': doc.id});
  }

  factory ElectronicsModel.fromMap(Map<String, dynamic> map) {
    return ElectronicsModel(
      params: ProductParams.fromMap(map),
      electronicsId: map['electronicsId'] ?? map['productId'] ?? '',
      productType: map['productType'] ?? '',
      operatingSystem: OperatingSystemModel.fromMap(map['operatingSystem'] ?? {},''),
    );
  }

  @override
  ElectronicsModel copyWith({
    String? id,
    String? storeId,
    String? name,
    String? description,
    double? price,
    String? transactionType,
    double? promotion,
    List<String>? imageUrls,
    List<String>? likes,
    ProductCategoryModel? category,
    List<Comment>? comments,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? dimensions,
    String? weight,
    BrandModel? brand,
    List<MaterialModel>? materials,
    CountryOfOriginModel? countryOfOrigin,
    String? returnPolicy,
    List<ColorModel>? colorOptions,
    String? barcode,
    bool? isAvailable,
    String? electronicsId,
    String? productType,
    OperatingSystemModel? operatingSystem,
  }) {
    return ElectronicsModel(
      params: params.copyWith(
        productId: id ?? params.productId,
        storeId: storeId ?? params.storeId,
        name: name ?? params.name,
        description: description ?? params.description,
        price: price ?? params.price,
        transactionType: transactionType ?? params.transactionType,
        promotion: promotion ?? params.promotion,
        imageUrls: imageUrls ?? params.imageUrls,
        likes: likes ?? params.likes,
        category: category ?? params.category,
        comments: comments ?? params.comments,
        stockQuantity: stockQuantity ?? params.stockQuantity,
        createdAt: createdAt ?? params.createdAt,
        updatedAt: updatedAt ?? params.updatedAt,
        dimensions: dimensions ?? params.dimensions,
        weight: weight ?? params.weight,
        brand: brand ?? params.brand,
        materials: materials ?? params.materials,
        countryOfOrigin: countryOfOrigin ?? params.countryOfOrigin,
        returnPolicy: returnPolicy ?? params.returnPolicy,
        colorOptions: colorOptions ?? params.colorOptions,
        barcode: barcode ?? params.barcode,
        isAvailable: isAvailable ?? params.isAvailable,
      ),
      electronicsId: electronicsId ?? this.electronicsId,
      productType: productType ?? this.productType,
      operatingSystem: operatingSystem ?? this.operatingSystem,
    );
  }
}