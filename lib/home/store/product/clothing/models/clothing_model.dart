import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';

class ClothingModel extends ProductModel {
  final String clothingId;
  final List<SizeModel> sizes;

  ClothingModel({
    required ProductParams params,
    required this.clothingId,
    required this.sizes,
  }) : super(params: params);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'clothingId': clothingId,
      'sizes': sizes.map((size) => size.toMap()).toList(),
      'categoryType': 'clothing',
    };
  }

  factory ClothingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClothingModel.fromMap({...data, 'productId': doc.id});
  }

  factory ClothingModel.fromMap(Map<String, dynamic> map) {
    return ClothingModel(
      params: ProductParams.fromMap(map),
      clothingId: map['clothingId'] ?? '',
      sizes: (map['sizes'] as List<dynamic>?)
              ?.map((sizeMap) => SizeModel.fromMap(sizeMap))
              .toList() ??
          [],
    );
  }

}