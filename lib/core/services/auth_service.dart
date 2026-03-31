// lib/core/services/auth_service.dart

import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/responses/auth_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final ApiService _api = Get.find<ApiService>();
  final StorageService _storage = Get.find<StorageService>();

  /// POST /api/auth/login
  Future<ApiResult> login({
    required String email,
    required String motDePasse,
  }) async {
    final result = await _api.post('/auth/login', body: {
      'email': email,
      'mot_de_passe': motDePasse,
    });

    if (result.success && result.responseData != null) {
      // ✅ Cast explicite de dynamic → Map<String, dynamic>
      final Map<String, dynamic> data =
          result.responseData as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);
      await _storage.saveSession(
        token: authResponse.token,
        user: authResponse.user,
      );
    }

    return result;
  }

  /// POST /api/auth/register
  Future<ApiResult> register({
    required String nom,
    String? postnom,
    required String prenom,
    required String email,
    required String telephone,
    required String motDePasse,
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'mot_de_passe': motDePasse,
    };
    if (postnom != null) body['postnom'] = postnom;

    final result = await _api.post('/auth/register', body: body);

    if (result.success && result.responseData != null) {
      // ✅ Cast explicite
      final Map<String, dynamic> data =
          result.responseData as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);
      await _storage.saveSession(
        token: authResponse.token,
        user: authResponse.user,
      );
    }

    return result;
  }

  /// POST /api/auth/change-password
  Future<ApiResult> changePassword({
    required String ancienMotDePasse,
    required String nouveauMotDePasse,
  }) async {
    return await _api.post('/auth/change-password', body: {
      'ancien_mot_de_passe': ancienMotDePasse,
      'nouveau_mot_de_passe': nouveauMotDePasse,
    });
  }

  /// GET /api/me
  Future<ApiResult> getProfile() async {
    final result = await _api.get('/me');

    if (result.success && result.responseData != null) {
      // ✅ Cast explicite
      final Map<String, dynamic> data =
          result.responseData as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      await _storage.saveUser(user);
    }

    return result;
  }

  /// PUT /api/me
  Future<ApiResult> updateProfile({
    String? nom,
    String? postnom,
    String? prenom,
    String? telephone,
  }) async {
    final body = <String, dynamic>{};
    if (nom != null) body['nom'] = nom;
    if (postnom != null) body['postnom'] = postnom;
    if (prenom != null) body['prenom'] = prenom;
    if (telephone != null) body['telephone'] = telephone;

    final result = await _api.put('/me', body: body);

    if (result.success && result.responseData != null) {
      // ✅ Cast explicite
      final Map<String, dynamic> data =
          result.responseData as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      await _storage.saveUser(user);
    }

    return result;
  }

  /// Déconnexion locale
  Future<void> logout() async {
    await _storage.clearSession();
  }

  /// Vérifie si l'utilisateur est connecté
  bool get isLoggedIn => _storage.isLoggedIn && _storage.hasToken;

  /// Utilisateur courant depuis le stockage
  UserModel? get currentUser => _storage.getUser();
}