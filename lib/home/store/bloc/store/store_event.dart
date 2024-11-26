// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class CreateStoreEvent extends StoreEvent {
  final String userId;
  final String storeBannerUrl;
  final String storeName;
  final String storeDescription;
  final String contactPhone;
  final String address;
  final Map<String, String> businessHours;
  final List<String> socialMediaLinks;

  const CreateStoreEvent({
    required this.userId,
    required this.storeBannerUrl,
    required this.storeName,
    required this.storeDescription,
    required this.contactPhone,
    required this.address,
    required this.businessHours,
    required this.socialMediaLinks,
  });

  @override
  List<Object?> get props => [
        userId,
        storeBannerUrl,
        storeName,
        storeDescription,
        contactPhone,
        address,
        businessHours,
        socialMediaLinks,
      ];
}

class UpdateStore extends StoreEvent {
  final String storeId;
  final Map<String, dynamic> updates;

  const UpdateStore(this.storeId, this.updates);

  @override
  List<Object> get props => [storeId, updates];
}

class DeleteStore extends StoreEvent {
  final String storeId;

  const DeleteStore(this.storeId);

  @override
  List<Object> get props => [storeId];
}

class GetStore extends StoreEvent {
  final String userId;

  const GetStore(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetStores extends StoreEvent {}

class GetPaginatedStores extends StoreEvent {
  final int limit;
  final DocumentSnapshot? startAfter;

  const GetPaginatedStores({this.limit = 10, this.startAfter});

  @override
  List<Object> get props => [limit];
}

class UpdateStoreRating extends StoreEvent {
  final String storeId;
  final double newRating;

  const UpdateStoreRating(this.storeId, this.newRating);

  @override
  List<Object> get props => [storeId, newRating];
}

class ToggleStoreActive extends StoreEvent {
  final String storeId;
  final bool isActive;

  const ToggleStoreActive(this.storeId, this.isActive);

  @override
  List<Object> get props => [storeId, isActive];
}
