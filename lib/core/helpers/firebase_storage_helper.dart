import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static Future<String> uploadImageToStorage(String path, Uint8List imageBytes) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error in uploadImageToStorage: $e');
      throw Exception('Image upload failed: $e');
    }
  }
}