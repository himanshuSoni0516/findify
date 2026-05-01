import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _key = 'theme_mode';
  final _mode = 0.obs; // 0=system, 1=light, 2=dark

  int get mode => _mode.value;

  ThemeMode get themeMode => switch (_mode.value) {
    1 => ThemeMode.light,
    2 => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _mode.value = prefs.getInt(_key) ?? 0;
    Get.changeThemeMode(themeMode);
  }

  Future<void> setTheme(int value) async {
    _mode.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, value);
    Get.changeThemeMode(themeMode);
  }
}