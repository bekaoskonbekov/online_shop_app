import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart' as picker;

class ImageService {
  final picker.ImagePicker _picker = picker.ImagePicker();

  Future<List<Uint8List>> selectAndCompressImages() async {
    final List<picker.XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      List<Uint8List> imageBytesList = await Future.wait(
        images.map((image) async {
          // Compress image directly from file
          Uint8List? compressedImageData = await FlutterImageCompress.compressWithFile(
            image.path,
            quality: 70,
          );

          return compressedImageData ?? Uint8List(0); // Return empty Uint8List if compression fails
        }),
      );
      return imageBytesList;
    } else {
      return [];
    }
  }
}
