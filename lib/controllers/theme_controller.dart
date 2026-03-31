import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final Rx<ThemeMode> currentTheme = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _storage.theme;
    if (savedTheme == 'dark') {
      currentTheme.value = ThemeMode.dark;
    } else {
      currentTheme.value = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    if (currentTheme.value == ThemeMode.dark) {
      currentTheme.value = ThemeMode.light;
      await _storage.saveTheme('light');
    } else {
      currentTheme.value = ThemeMode.dark;
      await _storage.saveTheme('dark');
    }
  }
}