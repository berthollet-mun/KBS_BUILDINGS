// lib/app/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  // --- État réactif ---
  final isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final isLoggedIn = false.obs;
  final errorMessage = ''.obs;
  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;

  // --- Controllers de formulaires ---
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController postnomController;
  late TextEditingController prenomController;
  late TextEditingController phoneController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  // --- Form Keys ---
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    postnomController = TextEditingController();
    prenomController = TextEditingController();
    phoneController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    _checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    postnomController.dispose();
    prenomController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  // --- Vérification état connexion ---
  void _checkLoginStatus() {
    isLoggedIn.value = _storageService.isLoggedIn;
    if (isLoggedIn.value) {
      currentUser.value = _storageService.getUser();
    }
  }

  // --- Toggle visibilité mot de passe ---
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void togglePasswordVisibility2() {
    isPasswordVisible2.value = !isPasswordVisible2.value;
  }

  // --- CONNEXION ---
  Future<void> login() async {
    if (loginFormKey.currentState == null ||
        !loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.login(
        email: emailController.text.trim(),
        motDePasse: passwordController.text,
      );

      if (result.success) {
        _checkLoginStatus();
        _clearLoginForm();
        Get.offAllNamed('/dashboard');
        Get.snackbar(
          'Succès',
          'Connexion réussie !',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        errorMessage.value = result.message;
        Get.snackbar(
          'Erreur de connexion',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorMessage.value = "Une erreur inattendue est survenue.";
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- INSCRIPTION ---
  Future<void> register() async {
    if (registerFormKey.currentState == null ||
        !registerFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.register(
        nom: nameController.text.trim(),
        postnom: postnomController.text.trim().isEmpty
            ? null
            : postnomController.text.trim(),
        prenom: prenomController.text.trim(),
        email: emailController.text.trim(),
        telephone: phoneController.text.trim(),
        motDePasse: passwordController.text,
      );

      if (result.success) {
        _checkLoginStatus();
        _clearRegisterForm();
        Get.offAllNamed('/dashboard');
        Get.snackbar(
          'Succès',
          'Inscription réussie ! Bienvenue.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = result.message;
        final validationErrors = result.validationErrors;
        if (validationErrors.isNotEmpty) {
          errorMessage.value = validationErrors.join('\n');
        }
        Get.snackbar(
          'Erreur d\'inscription',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      errorMessage.value = "Une erreur inattendue est survenue.";
      Get.snackbar('Erreur', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- CHANGEMENT MOT DE PASSE ---
  Future<void> changePassword() async {
    if (changePasswordFormKey.currentState == null ||
        !changePasswordFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.changePassword(
        ancienMotDePasse: oldPasswordController.text,
        nouveauMotDePasse: newPasswordController.text,
      );

      if (result.success) {
        oldPasswordController.clear();
        newPasswordController.clear();
        Get.back();
        Get.snackbar(
          'Succès',
          'Mot de passe modifié avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = result.message;
        Get.snackbar(
          'Erreur',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- RÉCUPÉRER LE PROFIL ---
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final result = await _authService.getProfile();
      if (result.success) {
        currentUser.value = _authService.currentUser;
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le profil',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- METTRE À JOUR LE PROFIL ---
  Future<void> updateProfile() async {
    if (profileFormKey.currentState == null ||
        !profileFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.updateProfile(
        nom: nameController.text.trim().isEmpty
            ? null
            : nameController.text.trim(),
        postnom: postnomController.text.trim().isEmpty
            ? null
            : postnomController.text.trim(),
        prenom: prenomController.text.trim().isEmpty
            ? null
            : prenomController.text.trim(),
        telephone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );

      if (result.success) {
        currentUser.value = _authService.currentUser;
        Get.snackbar(
          'Succès',
          'Profil mis à jour',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de mettre à jour le profil',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Pré-remplir le formulaire de profil ---
  void fillProfileForm() {
    final user = currentUser.value;
    if (user != null) {
      nameController.text = user.nom;          // ✅ String (pas nullable)
      postnomController.text = user.postnom ?? '';
      prenomController.text = user.prenom ?? '';
      phoneController.text = user.telephone ?? '';
      emailController.text = user.email;        // ✅ String (pas nullable)
    }
  }

  // --- DÉCONNEXION ---
  Future<void> logout() async {
    try {
      await _authService.logout();
      isLoggedIn.value = false;
      currentUser.value = null;
      Get.offAllNamed('/login');
      Get.snackbar(
        'Déconnexion',
        'Vous avez été déconnecté',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la déconnexion',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- Helpers privés ---
  void _clearLoginForm() {
    emailController.clear();
    passwordController.clear();
  }

  void _clearRegisterForm() {
    nameController.clear();
    postnomController.clear();
    prenomController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  // --- Getters utilitaires ---
  String get userFullName {
    final user = currentUser.value;
    if (user == null) return '';
    return user.nomComplet;  // ✅ Utilise le getter de UserModel
  }

  String get userRole {
    return currentUser.value?.roleNom ?? '';
  }

  String get userEmail {
    return currentUser.value?.email ?? '';
  }

  String get userPhone {
    return currentUser.value?.telephone ?? '';
  }

  bool get isAdmin => currentUser.value?.isAdmin ?? false;
  bool get isAgent => currentUser.value?.isAgent ?? false;
  bool get isProprietaire => currentUser.value?.isProprietaire ?? false;
  bool get isLocataire => currentUser.value?.isLocataire ?? false;
  bool get isTechnicien => currentUser.value?.isTechnicien ?? false;
  bool get isClient => currentUser.value?.isClient ?? false;

  bool get isAdminOrAgent => isAdmin || isAgent;
}