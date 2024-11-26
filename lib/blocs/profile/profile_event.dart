


import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends EditProfileEvent {
  final String uid;
  final String? bio;
  final String? email;
  final String? location;
  final String? name;
  final String? url;
  final String? username;
  final Uint8List? profileImage;

  const UpdateProfileRequested({
    required this.uid,
    this.bio,
    this.email,
    this.location,
    this.name,
    this.url,
    this.username,
    this.profileImage,
  });

  @override
  List<Object?> get props => [uid, bio, email, location, name, url, username, profileImage];
}


class GetProfileRequested extends EditProfileEvent {
  final String uid;

  const GetProfileRequested({required this.uid});

  @override
  List<Object?> get props => [uid];
}

