import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  final String storeId;
  final String userId;
  final String storeName;
  final String? storeDescription;
  final String? storeBannerUrl;
  final String? contactPhone;
  final String? address;
  final DateTime timestamp;
  final double? rating;
  final List<String>? socialMediaLinks;
  final bool isActive;
  final List<String>? products;
  final int followersCount;
  final bool isVerified;
  final Map<String, String>? businessHours;

  StoreModel({
    required this.storeId,
    required this.userId,
    required this.storeName,
    this.storeDescription,
    this.storeBannerUrl,
    this.contactPhone,
    this.address,
    required this.timestamp,
    this.rating,
    this.socialMediaLinks,
    this.isActive = true,
    this.products,
    this.followersCount = 0,
    this.isVerified = false,
    this.businessHours,
  });

  @override
  List<Object?> get props => [
        storeId,
        userId,
        storeName,
        storeDescription,
        storeBannerUrl,
        contactPhone,
        address,
        timestamp,
        rating,
        socialMediaLinks,
        isActive,
        products,
        followersCount,
        isVerified,
        businessHours,
      ];

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'userId': userId,
      'storeName': storeName,
      'storeDescription': storeDescription,
      'storeBannerUrl': storeBannerUrl,
      'contactPhone': contactPhone,
      'address': address,
      'timestamp': timestamp,
      'rating': rating,
      'socialMediaLinks': socialMediaLinks,
      'isActive': isActive,
      'products': products,
      'followersCount': followersCount,
      'isVerified': isVerified,
      'businessHours': businessHours,
    };
  }

  factory StoreModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return StoreModel(
      storeId: doc.id,
      userId: map['userId'] ?? '',
      storeName: map['storeName'] ?? '',
      storeDescription: map['storeDescription'],
      storeBannerUrl: map['storeBannerUrl'],
      contactPhone: map['contactPhone'],
      address: map['address'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      rating: map['rating']?.toDouble(),
      socialMediaLinks: List<String>.from(map['socialMediaLinks'] ?? []),
      isActive: map['isActive'] ?? true,
      products: List<String>.from(map['products'] ?? []),
      followersCount: map['followersCount'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      businessHours: Map<String, String>.from(map['businessHours'] ?? {}),
    );
  }
}