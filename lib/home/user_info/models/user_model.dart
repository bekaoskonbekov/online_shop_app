import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String photoUrl;
  final String username;
  final String name;
  final String bio;
  final String url;
  final String location;
  final List<String> followers;
  final List<String> following;
  final bool isOnline;
  final DateTime lastSeen;

  UserModel({
    required this.uid,
    required this.email,
    this.photoUrl = '',
    this.username = '',
    this.name = '',
    this.bio = '',
    this.url = '',
    this.location = '',
    this.followers = const [],
    this.following = const [],
    this.isOnline = false,
    DateTime? lastSeen, // Optional parameter
  }) : lastSeen = lastSeen ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory UserModel.fromFirebaseUser(User firebaseUser, {String name = ''}) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      username: firebaseUser.displayName ?? '',
      name: name.isNotEmpty ? name : firebaseUser.displayName ?? '',
      isOnline: true,
      lastSeen: DateTime.now(),
    );
  }

 factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
  return UserModel(
    uid: uid,
    email: data['email'] ?? '',
    photoUrl: data['photoUrl'] ?? '',
    username: data['username'] ?? '',
    name: data['name'] ?? '',
    bio: data['bio'] ?? '',
    url: data['url'] ?? '',
    location: data['location'] ?? '',
    followers: List<String>.from(data['followers'] ?? []),
    following: List<String>.from(data['following'] ?? []),
    isOnline: data['isOnline'] ?? false,
    lastSeen: (data['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}

 factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    uid: map['uid'] ?? '',
    email: map['email'] ?? '',
    photoUrl: map['photoUrl'] ?? '',
    username: map['username'] ?? '',
    name: map['name'] ?? '',
    bio: map['bio'] ?? '',
    url: map['url'] ?? '',
    location: map['location'] ?? '',
    followers: List<String>.from(map['followers'] ?? []),
    following: List<String>.from(map['following'] ?? []),
    isOnline: map['isOnline'] ?? false,
    lastSeen: map['lastSeen'] != null
        ? (map['lastSeen'] as Timestamp).toDate()
        : DateTime.fromMillisecondsSinceEpoch(0),
  );
}

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'username': username,
      'name': name,
      'bio': bio,
      'url': url,
      'location': location,
      'followers': followers,
      'following': following,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}