import 'package:flutter/material.dart';
import 'package:my_example_file/core/utils/styles/app_colors.dart';

class LightTheme {
  static final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    canvasColor: AppColors.surfaceLight,
    cardColor: AppColors.surfaceLight,
    dialogBackgroundColor: AppColors.surfaceLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    dividerColor: AppColors.dividerColorLight,
    focusColor: AppColors.primaryLight.withOpacity(0.12),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      background: AppColors.backgroundLight,
      error: AppColors.errorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 238, 44)),
      elevation: 0,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color.fromARGB(255, 19, 255, 6),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: Color.fromARGB(255, 0, 238, 67),
      unselectedItemColor: AppColors.textSecondaryLight,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColorPrimary,
        foregroundColor: Colors.white,
      ),
    ),
    
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: AppColors.textPrimaryLight),
      bodyMedium: const TextStyle(color: AppColors.textPrimaryLight),
      bodySmall: const TextStyle(color: AppColors.textSecondaryLight),
       titleLarge: TextStyle(
        foreground: Paint()..shader = AppColors.textGradient,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryLight,
      selectionColor: AppColors.primaryLight,
      selectionHandleColor: AppColors.primaryLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      iconColor: AppColors.iconColorLight,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.dividerColorLight),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

class DarkTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    canvasColor: AppColors.surfaceDark,
    cardColor: AppColors.surfaceDark,
    dialogBackgroundColor: AppColors.surfaceDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    dividerColor: AppColors.dividerColorDark,
    focusColor: AppColors.primaryDark.withOpacity(0.12),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 7, 211, 45),
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
      error: AppColors.errorDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 7, 211, 45)),
      elevation: 0,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primaryDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: Color.fromARGB(255, 7, 211, 45),
      unselectedItemColor: AppColors.textSecondaryDark,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Color.fromARGB(255, 7, 211, 45),
        side: const BorderSide(color: AppColors.surfaceDark),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Color.fromARGB(255, 7, 211, 45),
        side: const BorderSide(color: AppColors.surfaceDark),
      ),),
   
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: AppColors.textPrimaryDark),
      bodyMedium: const TextStyle(color: AppColors.textPrimaryDark),
      bodySmall: const TextStyle(color: AppColors.textSecondaryDark),
      titleLarge: TextStyle(
        foreground: Paint()..shader = AppColors.textGradient,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryDark,
      selectionColor: AppColors.primaryDark,
      selectionHandleColor: AppColors.primaryDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      iconColor: AppColors.iconColorDark,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.dividerColorDark),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryDark),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
