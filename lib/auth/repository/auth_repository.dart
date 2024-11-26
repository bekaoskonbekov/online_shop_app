import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../home/user_info/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userData['name'] ?? '',
          );
        } else {
          return UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: '',
          );
        }
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
    return null;
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!, name: name);
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.name,
          'photoUrl': user.photoUrl,
          'username': user.username,
          'bio': user.bio,
          'url': user.url,
          'location': user.location,
          'followers': user.followers,
          'following': user.following,
        });
        return user;
      }
    } catch (e) {
      print('Sign up error: $e');
    }
    return null;
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
        }, SetOptions(merge: true));

        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
        );
      }
    } catch (e) {
      print('Google sign in error: $e');
    }
    return null;
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            uid: currentUser.uid,
            email: currentUser.email ?? '',
            name: userData['name'] ?? '',
          );
        } else {
          return UserModel(
            uid: currentUser.uid,
            email: currentUser.email ?? '',
            name: '',
          );
        }
      } catch (e) {
        print('Error getting user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> updateUserProfile({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? username,
    String? bio,
    String? url,
    String? location,
    List<String>? followers,
    List<String>? following,
  }) async {
    try {
      String userId = uid ?? _firebaseAuth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('Колдонуучу ID табылган жок');
      }

      Map<String, dynamic> updateData = {};

      if (email != null) updateData['email'] = email;
      if (name != null) updateData['name'] = name;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (username != null) updateData['username'] = username;
      if (bio != null) updateData['bio'] = bio;
      if (url != null) updateData['url'] = url;
      if (location != null) updateData['location'] = location;
      if (followers != null) updateData['followers'] = followers;
      if (following != null) updateData['following'] = following;

      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(userId).set(updateData, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Колдонуучу профилин жаңыртууда ката кетти: $e');
      return false;
    }
  }
}
