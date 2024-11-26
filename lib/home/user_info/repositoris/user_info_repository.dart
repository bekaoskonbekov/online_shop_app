import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/core/helpers/firebase_storage_helper.dart';

class EditProfileRepository {
  final FirebaseFirestore _firestore;

  EditProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> updateProfile({
    required String uid,
    String? bio,
    String? email,
    String? location,
    String? name,
    String? photoUrl,
    String? url,
    String? username,
    Uint8List? profileImage,
  }) async {
    String res = "404";
    try {
      Map<String, dynamic> updateData = {};

      if (bio != null) updateData['bio'] = bio;
      if (email != null) updateData['email'] = email;
      if (location != null) updateData['location'] = location;
      if (name != null) updateData['name'] = name;
      if (url != null) updateData['url'] = url;
      if (username != null) updateData['username'] = username;

      if (profileImage != null) {
        String updatedImageUrl = await FirebaseStorageHelper.uploadImageToStorage("userImage/$uid", profileImage);
        updateData['photoUrl'] = updatedImageUrl;
      } else if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }

      await _firestore.collection("users").doc(uid).update(updateData);
      res = "200";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  

   Future<Map<String, dynamic>?> getProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error getting profile: $e");
    }
    return null;
  }
}

