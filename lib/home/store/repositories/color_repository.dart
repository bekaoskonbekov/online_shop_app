import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';

class ColorRepository extends BaseRepository<ColorModel> {
  ColorRepository({FirebaseFirestore? firestore})
      : super(firestore ?? FirebaseFirestore.instance, 'colors');

  @override
  ColorModel fromFirestore(DocumentSnapshot doc) {
    return ColorModel.fromFirestore(doc);
  }

  Future<void> initializeColors(List<Map<String, dynamic>> colors) async {
    try {
      await initialize(colors);
    } catch (e) {
      throw handleException('Түстөрдү инициализациялоодо ката кетти', e);
    }
  }

  Future<List<ColorModel>> getAllColors() async {
    return getAll();
  }

  Future<ColorModel?> getColorById(String colorId) async {
    return getById(colorId);
  }

  Future<void> addProductToColor(String productId, String colorId) async {
    return addToArray(colorId, 'productIds', productId);
  }
}
