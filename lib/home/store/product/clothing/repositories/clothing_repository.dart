import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/product/clothing/models/clothing_model.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/size_repository.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class ClothingRepository extends BaseRepository<ClothingModel> {
  final SizeRepository _sizeRepository;

  ClothingRepository({FirebaseFirestore? firestore})
      : _sizeRepository = SizeRepository(firestore: firestore),
        super(firestore ?? FirebaseFirestore.instance, 'products');

  @override
  ClothingModel fromFirestore(DocumentSnapshot doc) {
    return ClothingModel.fromFirestore(doc);
  }

  @override
  Future<ClothingModel> createClothings(ClothingModel clothing) async {
    try {
      final result = await super.create(clothing);
      if (clothing.sizes.isNotEmpty) {
        await _sizeRepository.updateSizesForProduct(result.clothingId, clothing.sizes);
      }
      return result;
    } catch (e) {
      throw handleException('Кийим түзүүдө ката кетти', e);
    }
  }

  Future<List<ClothingModel>> getAllClothings() async {
    try {
      return getByField('categoryType', 'clothing');
    } catch (e) {
      throw handleException('Кийимдерди алууда ката кетти', e);
    }
  }

  Future<ClothingModel?> getClothingById(String id) async {
    return getById(id);
  }

  Future<List<ClothingModel>> getClothingsByBrand(String brandId) async {
    return getByField('brandId', brandId);
  }
}