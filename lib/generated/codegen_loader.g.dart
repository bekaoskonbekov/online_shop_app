// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en_EN = {
  "hello_world": "Hello, World"
};
static const Map<String,dynamic> ky_KG = {
  "hello_world": "Салам дүйнө"
};
static const Map<String,dynamic> ru_RU = {
  "hello_world": "Привет, мир"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_EN": en_EN, "ky_KG": ky_KG, "ru_RU": ru_RU};
}
