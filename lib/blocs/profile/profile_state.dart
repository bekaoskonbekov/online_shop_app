import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileFailure extends EditProfileState {
  final String error;

  const EditProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileLoaded extends EditProfileState {
  final UserModel profileData;

  const ProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}
