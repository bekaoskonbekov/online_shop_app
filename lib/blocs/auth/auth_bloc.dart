import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/user_info/models/user_model.dart';
import 'package:my_example_file/auth/repository/auth_repository.dart';
import 'package:my_example_file/core/helpers/chace_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
     on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _saveUserData(UserModel user) async {
    await CacheHelper.setSecure(CacheKey.uid.toString(), user.uid);
    await CacheHelper.setString(CacheKey.email, user.email);
  }

  void _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        await _saveUserData(user);
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await _authRepository.signOut();
    await CacheHelper.removeSecure(CacheKey.uid.toString());
    await CacheHelper.remove(CacheKey.email);
    emit(AuthInitial());
  }

  void _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
     emit(AuthLoading());
  try {
    final currentUser = await _authRepository.getCurrentUser();
    if (currentUser != null) {
      final storedUid = await CacheHelper.getSecure(CacheKey.uid.toString());
      if (storedUid == currentUser.uid) {
        emit(Authenticated(currentUser));
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

  void _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password, name: event.name,
      );
      if (user != null) {
        await _saveUserData(user);
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
   void _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        await _saveUserData(user);
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Google sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}





  




