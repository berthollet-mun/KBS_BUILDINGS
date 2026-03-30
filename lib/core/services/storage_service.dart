import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  // Clés de stockage
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _themeKey = 'app_theme';
  static const String _firstLaunchKey = 'first_launch';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ========== TOKEN ==========

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  bool get hasToken => getToken() != null && getToken()!.isNotEmpty;

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  // ========== USER ==========

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  UserModel? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    try {
      final Map<String, dynamic> decoded = jsonDecode(userJson);
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  // ========== AUTH STATE ==========

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  // ========== SESSION COMPLÈTE ==========

  Future<void> saveSession({
    required String token,
    required UserModel user,
  }) async {
    await saveToken(token);
    await saveUser(user);
    await setLoggedIn(true);
  }

  Future<void> clearSession() async {
    await removeToken();
    await removeUser();
    await setLoggedIn(false);
  }

  // ========== THEME ==========

  Future<void> saveTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  String get theme => _prefs.getString(_themeKey) ?? 'light';

  bool get isDarkMode => theme == 'dark';

  // ========== FIRST LAUNCH ==========

  bool get isFirstLaunch => _prefs.getBool(_firstLaunchKey) ?? true;

  Future<void> setFirstLaunchDone() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  // ========== GÉNÉRIQUE ==========

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}