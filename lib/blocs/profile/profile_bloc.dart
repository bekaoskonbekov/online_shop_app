import 'package:bloc/bloc.dart';
import 'package:my_example_file/blocs/profile/profile_event.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/user_info/repositoris/user_info_repository.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';


class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepository editrepository;

  EditProfileBloc({required this.editrepository}) : super(EditProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
     on<GetProfileRequested>(_onGetProfileRequested);
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    try {
      final result = await editrepository.updateProfile(
        uid: event.uid,
        bio: event.bio,
        email: event.email,
        location: event.location,
        name: event.name,
        url: event.url,
        username: event.username,
        profileImage: event.profileImage,
      );
      if (result == "200") {
        emit(EditProfileSuccess());
      } else {
        emit(EditProfileFailure(result));
      }
    } catch (e) {
      emit(EditProfileFailure(e.toString()));
    }
  }
Future<void> _onGetProfileRequested(
  GetProfileRequested event,
  Emitter<EditProfileState> emit,
) async {
  emit(EditProfileLoading());
  try {
    final profileData = await editrepository.getProfile(event.uid);
    if (profileData != null) {
      final userModel = UserModel.fromFirestore(profileData, event.uid);
      emit(ProfileLoaded(userModel));
    } else {
      emit(EditProfileFailure("Profile not found"));
    }
  } catch (e) {
    emit(EditProfileFailure(e.toString()));
  }
}


}
