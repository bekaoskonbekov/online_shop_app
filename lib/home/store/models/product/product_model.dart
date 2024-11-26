import 'package:my_example_file/home/posts/models/comment_model.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/material_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/models/product_category.dart';

class ProductModel {
  final ProductParams params;

  ProductModel({required this.params});

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(params: ProductParams.fromMap(map));
  }

  Map<String, dynamic> toMap() => params.toMap();

  ProductModel copyWith({
    String? id,  // Changed from productId to id
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
  }) {
    return ProductModel(
      params: params.copyWith(
        productId: id ?? params.productId,  // Use id here
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
    );
  }
}