// lib/app/controllers/user_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/user_service.dart';
import '../../data/models/user_model.dart';
import '../../data/responses/paginated_response.dart';

class UserController extends GetxController {
  final UserService _service = Get.find<UserService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<UserModel> usersList = <UserModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  final detailError = ''.obs;

  // --- Sauvegarde ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Recherche ---
  final searchQuery = ''.obs;

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  late TextEditingController nomController;
  late TextEditingController postnomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  late TextEditingController telephoneController;
  late TextEditingController motDePasseController;
  final formRoleId = Rx<int?>(null);
  final formStatut = 'actif'.obs;

  final List<String> statuts = ['actif', 'inactif'];

  @override
  void onInit() {
    super.onInit();
    nomController = TextEditingController();
    postnomController = TextEditingController();
    prenomController = TextEditingController();
    emailController = TextEditingController();
    telephoneController = TextEditingController();
    motDePasseController = TextEditingController();
    fetchUsers();

    debounce(searchQuery, (_) => fetchUsers(refresh: true),
        time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    nomController.dispose();
    postnomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    motDePasseController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchUsers({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      usersList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getUsers(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<UserModel> response =
            _service.parsePaginatedUsers(result);
        usersList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des utilisateurs.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getUsers(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<UserModel> response =
            _service.parsePaginatedUsers(result);
        usersList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchUserDetails(int id) async {
    isDetailLoading.value = true;
    selectedUser.value = null;
    detailError.value = '';

    try {
      final result = await _service.getUser(id);
      if (result.success) {
        selectedUser.value = _service.parseUser(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails de l'utilisateur.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) return;
    if (formRoleId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un rôle',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _service.createUser(
        nom: nomController.text.trim(),
        postnom: postnomController.text.trim().isEmpty
            ? null
            : postnomController.text.trim(),
        prenom: prenomController.text.trim(),
        email: emailController.text.trim(),
        telephone: telephoneController.text.trim().isEmpty
            ? null
            : telephoneController.text.trim(),
        motDePasse: motDePasseController.text,
        roleId: formRoleId.value!,
        statut: formStatut.value,
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchUsers(refresh: true);
        Get.snackbar('Succès', 'Utilisateur créé avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer l\'utilisateur',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MODIFICATION ==========

  void fillForm(UserModel user) {
    nomController.text = user.nom ?? '';
    postnomController.text = user.postnom ?? '';
    prenomController.text = user.prenom ?? '';
    emailController.text = user.email ?? '';
    telephoneController.text = user.telephone ?? '';
    formRoleId.value = user.roleId;
    formStatut.value = user.statut ?? 'actif';
  }

  Future<void> updateUser(int id) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final data = <String, dynamic>{};
      if (nomController.text.isNotEmpty) {
        data['nom'] = nomController.text.trim();
      }
      if (postnomController.text.isNotEmpty) {
        data['postnom'] = postnomController.text.trim();
      }
      if (prenomController.text.isNotEmpty) {
        data['prenom'] = prenomController.text.trim();
      }
      if (telephoneController.text.isNotEmpty) {
        data['telephone'] = telephoneController.text.trim();
      }
      if (formRoleId.value != null) {
        data['role_id'] = formRoleId.value;
      }
      data['statut'] = formStatut.value;

      final result = await _service.updateUser(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchUsers(refresh: true);
        Get.snackbar('Succès', 'Utilisateur modifié',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier l\'utilisateur',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== SUPPRESSION (DÉSACTIVATION) ==========

  Future<void> deleteUser(int id) async {
    try {
      final result = await _service.deleteUser(id);
      if (result.success) {
        // Met à jour localement
        final index = usersList.indexWhere((u) => u.id == id);
        if (index != -1) {
          // L'utilisateur est désactivé, pas supprimé
          fetchUsers(refresh: true);
        }
        Get.snackbar('Succès', 'Utilisateur désactivé',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de désactiver l\'utilisateur',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void confirmDelete(int id, String nom) {
    Get.defaultDialog(
      title: 'Désactiver l\'utilisateur',
      middleText:
          'Voulez-vous vraiment désactiver "$nom" ? Il ne pourra plus se connecter.',
      textCancel: 'Annuler',
      textConfirm: 'Désactiver',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        deleteUser(id);
      },
    );
  }

  void _clearForm() {
    nomController.clear();
    postnomController.clear();
    prenomController.clear();
    emailController.clear();
    telephoneController.clear();
    motDePasseController.clear();
    formRoleId.value = null;
    formStatut.value = 'actif';
  }
}