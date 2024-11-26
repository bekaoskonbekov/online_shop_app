import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/material_model.dart';
import 'package:my_example_file/home/store/models/product_category.dart';

class ProductParams {
  final String? productId;
  final String? storeId;
  final String? name;
  final String? description;
  final double? price;
  final String? transactionType;
  final double? promotion;
  final List<String>? imageUrls;
  final List<String>? likes;
  final ProductCategoryModel? category;
  final List<Comment>? comments;
  final int? stockQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? dimensions;
  final String? weight;
  final BrandModel? brand;
  final List<MaterialModel>? materials;
  final CountryOfOriginModel? countryOfOrigin;
  final String? returnPolicy;
  final List<ColorModel>? colorOptions;
  final String? barcode;
  final bool? isAvailable;

  ProductParams({
    this.productId,
    this.storeId,
    this.name,
    this.description,
    this.price,
    this.transactionType,
    this.promotion,
    this.imageUrls,
    this.likes,
    this.category,
    this.comments,
    this.stockQuantity,
    this.createdAt,
    this.updatedAt,
    this.dimensions,
    this.weight,
    this.brand,
    this.materials,
    this.countryOfOrigin,
    this.returnPolicy,
    this.colorOptions,
    this.barcode,
    this.isAvailable,
  });

  ProductParams copyWith({
    String? productId,
    String? storeId,
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    ProductCategoryModel? category,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? transactionType,
    double? promotion,
    List<String>? likes,
    List<Comment>? comments,
    Map<String, dynamic>? dimensions,
    String? weight,
    BrandModel? brand,
    List<MaterialModel>? materials,
    CountryOfOriginModel? countryOfOrigin,
    String? returnPolicy,
    List<ColorModel>? colorOptions,
    String? barcode,
    bool? isAvailable,
  }) {
    return ProductParams(
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactionType: transactionType ?? this.transactionType,
      promotion: promotion ?? this.promotion,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      brand: brand ?? this.brand,
      materials: materials ?? this.materials,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      colorOptions: colorOptions ?? this.colorOptions,
      barcode: barcode ?? this.barcode,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'storeId': storeId,
      'name': name,
      'description': description,
      'price': price,
      'transactionType': transactionType,
      'promotion': promotion,
      'imageUrls': imageUrls,
      'likes': likes,
      'category': category?.toMap(),
      'comments': comments?.map((comment) => comment.toMap()).toList(),
      'stockQuantity': stockQuantity,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'dimensions': dimensions,
      'weight': weight,
      'brand': brand?.toMap(),
      'materials': materials?.map((material) => material.toMap()).toList(),
      'countryOfOrigin': countryOfOrigin?.toMap(),
      'returnPolicy': returnPolicy,
      'colorOptions': colorOptions?.map((color) => color.toMap()).toList(),
      'barcode': barcode,
      'isAvailable': isAvailable,
    };
  }

  factory ProductParams.fromMap(Map<String, dynamic> map) {
    return ProductParams(
      productId: map['productId'],
      storeId: map['storeId'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toDouble(),
      transactionType: map['transactionType'],
      promotion: map['promotion']?.toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      category: map['category'] != null ? ProductCategoryModel.fromMap(map['category']) : null,
      comments: map['comments'] != null
          ? List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x)))
          : null,
      stockQuantity: map['stockQuantity']?.toInt(),
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      dimensions: Map<String, dynamic>.from(map['dimensions'] ?? {}),
      weight: map['weight'],
      brand: map['brand'] != null ? BrandModel.fromMap(map['brand']) : null,
      materials: map['materials'] != null
          ? List<MaterialModel>.from(map['materials']?.map((x) => MaterialModel.fromMap(x)))
          : null,
      countryOfOrigin: map['countryOfOrigin'] != null
          ? CountryOfOriginModel.fromMap(map['countryOfOrigin'])
          : null,
      returnPolicy: map['returnPolicy'],
      colorOptions: map['colorOptions'] != null
          ? List<ColorModel>.from(map['colorOptions']?.map((x) => ColorModel.fromMap(x)))
          : null,
      barcode: map['barcode'],
      isAvailable: map['isAvailable'],
    );
  }
}