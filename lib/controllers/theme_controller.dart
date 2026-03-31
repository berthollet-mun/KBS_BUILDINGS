// lib/app/controllers/theme_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final isDarkMode = false.obs;
  final Rx<ThemeMode> currentTheme = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.isDarkMode;
    currentTheme.value =
        isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  /// Basculer entre mode sombre et clair
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    currentTheme.value =
        isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
    _storage.saveTheme(isDarkMode.value ? 'dark' : 'light');
    Get.changeThemeMode(currentTheme.value);
  }

  /// Appliquer un thème spécifique
  void setDarkMode(bool value) {
    isDarkMode.value = value;
    currentTheme.value = value ? ThemeMode.dark : ThemeMode.light;
    _storage.saveTheme(value ? 'dark' : 'light');
    Get.changeThemeMode(currentTheme.value);
  }

  ThemeMode get themeMode => currentTheme.value;
}