import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  final String lastOpenedPage;

  final Locale locale;
  final ThemeMode themeMode;

  const AppState({
    required this.lastOpenedPage,

    required this.locale,
    required this.themeMode,
  });

  @override
  List<Object?> get props => [
        lastOpenedPage,
        locale,
        themeMode
      ];
}

extension AppStateCopyWith on AppState {
  AppState copyWith({
    String? lastOpenedPage,

    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppState(
      lastOpenedPage: lastOpenedPage ?? this.lastOpenedPage,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
