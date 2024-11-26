import 'dart:typed_data';
import 'package:my_example_file/core/helpers/firebase_storage_helper.dart';

class FirebaseService {
  Future<List<String>> uploadImagesToFirebase(List<Uint8List> images) async {
    try {
      List<String> imageUrls = await Future.wait(
        images.map((image) async {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          String imagePath = 'posts/$fileName.jpg';
          return await FirebaseStorageHelper.uploadImageToStorage(imagePath, image);
        }),
      );
      return imageUrls;
    } catch (e) {
      throw Exception('Сүрөт жүктөөдө ката кетти: $e');
    }
  }
}
