import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/app/app_event.dart';
import 'package:my_example_file/blocs/app/app_state.dart';
import 'package:my_example_file/core/helpers/chace_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppState> {
  AppStateBloc()
      : super(const AppState(
          lastOpenedPage: 'home', 
          
          locale: Locale('en', 'EN'),
          themeMode: ThemeMode.system,
        )) {
    on<LoadAppState>(_onLoadAppState);
    on<UpdateLastOpenedPage>(_onUpdateLastOpenedPage);
    
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadAppState(
      LoadAppState event, Emitter<AppState> emit) async {
    final lastOpenedPage =
        CacheHelper.getString(CacheKey.lastOpenedPage) ?? 'home';
   
    final languageCode = CacheHelper.getString(CacheKey.languageCode) ?? 'en';
    final countryCode = CacheHelper.getString(CacheKey.countryCode) ?? 'EN';
    final locale = Locale(languageCode, countryCode);

    final themeModeString = CacheHelper.getString(CacheKey.theme);
    final ThemeMode themeMode;
    if (themeModeString != null) {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.$themeModeString',
        orElse: () => ThemeMode.system,
      );
    } else {
      themeMode = ThemeMode.system;
    }

    emit(AppState(
      lastOpenedPage: lastOpenedPage,

      locale: locale,
      themeMode: themeMode,
    ));

  }
  Future<void> _onUpdateLastOpenedPage(
      UpdateLastOpenedPage event, Emitter<AppState> emit) async {
    try {
      await CacheHelper.setString(CacheKey.lastOpenedPage, event.page);
      emit(state.copyWith(lastOpenedPage: event.page));
    } catch (e) {
      print('Caktalgan jok');
    }
  }












  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<AppState> emit) async {
    await event.context.setLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
    }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<AppState> emit) async {
    final currentTheme = state.themeMode;
    ThemeMode newTheme;

    if (currentTheme == ThemeMode.light) {
      newTheme = ThemeMode.dark;
    } else if (currentTheme == ThemeMode.dark) {
      newTheme = ThemeMode.system;
    } else {
      newTheme = ThemeMode.light;
    }
    await CacheHelper.setString(
        CacheKey.theme, newTheme.toString().split('.').last);

    emit(state.copyWith(themeMode: newTheme));
  }
}
