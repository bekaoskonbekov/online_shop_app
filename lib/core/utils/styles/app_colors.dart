import 'package:flutter/material.dart';

class AppColors {
  // Негизги түстөр
  static const Color primaryLight = Color(0xFF6200EE); // Google Material Primary Color
  static const Color primaryDark = Color(0xFFBB86FC); // Dark variant of primary color
  static const Color secondaryLight = Color(0xFF03DAC6); // Google Material Secondary Color
  static const Color secondaryDark = Color(0xFF03DAC6); // Dark variant of secondary color
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure White
  static const Color backgroundDark = Color(0xFF121212); // Dark background color
  static const Color surfaceLight = Color(0xFFF5F5F5); // Light surface color
  static const Color surfaceDark = Color(0xFF1F1F1F); // Dark surface color
  static const Color errorLight = Color(0xFFD32F2F); // Light error color
  static const Color errorDark = Color(0xFFCF6679); // Dark error color

  // Текст түстөрү
  static const Color textPrimaryLight = Color(0xFF212121); // Almost Black for light theme text
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White for dark theme text
  static const Color textSecondaryLight = Color(0xFF757575); // Gray for light theme text
  static const Color textSecondaryDark = Color(0xFFB3B3B3); // Lighter Gray for dark theme text

  // Иконка түстөрү
  static const Color iconColorLight = primaryLight;
  static const Color iconColorDark = primaryDark;

  // Divider түстөрү
  static const Color dividerColorLight = Color(0xFFE0E0E0); // Light Gray for dividers
  static const Color dividerColorDark = Color(0xFF292929); // Dark Gray for dividers

  // Button түстөрү
  static const Color buttonColorPrimary = primaryLight;
  static const Color buttonColorSecondary = Color(0xFFFF5722); // Deep Orange for secondary buttons

  // Популярдуу Градиенттер
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)], // Blueish gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFF857A6), Color(0xFFFF5858)], // Pink to Red gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)], // Purple gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF56ab2f), Color(0xFFA8E063)], // Green gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF8008), Color(0xFFFFC837)], // Orange gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final Shader textGradient = LinearGradient(
    colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)], // Blue gradient for text
  ).createShader(Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));
}
