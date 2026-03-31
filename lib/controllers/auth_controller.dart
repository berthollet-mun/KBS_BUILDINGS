import 'package:get/get.dart';
import '../core/services/auth_service.dart';
import '../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  bool get isLoggedIn => _authService.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.currentUser;
  }

  Future<bool> login({
    required String email,
    required String motDePasse,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _authService.login(
        email: email,
        motDePasse: motDePasse,
      );

      if (result.success) {
        user.value = _authService.currentUser;
        return true;
      }

      error.value = result.message.isNotEmpty
          ? result.message
          : 'Connexion échouée';
      return false;
    } catch (e) {
      error.value = 'Erreur de connexion: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String nom,
    String? postnom,
    required String prenom,
    required String email,
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _authService.register(
        nom: nom,
        postnom: postnom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        motDePasse: motDePasse,
      );

      if (result.success) {
        user.value = _authService.currentUser;
        return true;
      }

      error.value = result.message.isNotEmpty
          ? result.message
          : 'Inscription échouée';
      return false;
    } catch (e) {
      error.value = 'Erreur d\'inscription: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loadProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _authService.getProfile();

      if (result.success) {
        user.value = _authService.currentUser;
        return true;
      }

      error.value = result.message.isNotEmpty
          ? result.message
          : 'Impossible de charger le profil';
      return false;
    } catch (e) {
      error.value = 'Erreur de chargement: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? nom,
    String? postnom,
    String? prenom,
    String? telephone,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _authService.updateProfile(
        nom: nom,
        postnom: postnom,
        prenom: prenom,
        telephone: telephone,
      );

      if (result.success) {
        user.value = _authService.currentUser;
        return true;
      }

      error.value = result.message.isNotEmpty
          ? result.message
          : 'Mise à jour impossible';
      return false;
    } catch (e) {
      error.value = 'Erreur: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user.value = null;
    Get.offAllNamed('/welcome');
  }

  Future<bool> checkAuth() async {
    user.value = _authService.currentUser;
    return isLoggedIn;
  }
}