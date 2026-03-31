// lib/app/controllers/proprietaire_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/proprietaire_service.dart';
import '../../data/models/proprietaire_model.dart';
import '../../data/responses/paginated_response.dart';

class ProprietaireController extends GetxController {
  final ProprietaireService _service = Get.find<ProprietaireService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<ProprietaireModel> proprietairesList =
      <ProprietaireModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<ProprietaireModel?> selectedProprietaire =
      Rx<ProprietaireModel?>(null);
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
  late TextEditingController nomCompletController;
  late TextEditingController telephoneController;
  late TextEditingController emailController;
  late TextEditingController adresseController;
  late TextEditingController pieceIdentiteController;

  @override
  void onInit() {
    super.onInit();
    nomCompletController = TextEditingController();
    telephoneController = TextEditingController();
    emailController = TextEditingController();
    adresseController = TextEditingController();
    pieceIdentiteController = TextEditingController();
    fetchProprietaires();

    debounce(searchQuery, (_) => fetchProprietaires(refresh: true),
        time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    nomCompletController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    adresseController.dispose();
    pieceIdentiteController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchProprietaires({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      proprietairesList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getProprietaires(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<ProprietaireModel> response =
            _service.parsePaginatedProprietaires(result);
        proprietairesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des propriétaires.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreProprietaires() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getProprietaires(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<ProprietaireModel> response =
            _service.parsePaginatedProprietaires(result);
        proprietairesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchProprietaireDetails(int id) async {
    isDetailLoading.value = true;
    selectedProprietaire.value = null;
    detailError.value = '';

    try {
      final result = await _service.getProprietaire(id);
      if (result.success) {
        selectedProprietaire.value = _service.parseProprietaire(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails du propriétaire.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createProprietaire() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final result = await _service.createProprietaire(
        nomComplet: nomCompletController.text.trim(),
        telephone: telephoneController.text.trim().isEmpty
            ? null
            : telephoneController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        adresse: adresseController.text.trim().isEmpty
            ? null
            : adresseController.text.trim(),
        pieceIdentite: pieceIdentiteController.text.trim().isEmpty
            ? null
            : pieceIdentiteController.text.trim(),
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchProprietaires(refresh: true);
        Get.snackbar('Succès', 'Propriétaire créé avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le propriétaire',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MODIFICATION ==========

  void fillForm(ProprietaireModel proprietaire) {
    nomCompletController.text = proprietaire.nomComplet ?? '';
    telephoneController.text = proprietaire.telephone ?? '';
    emailController.text = proprietaire.email ?? '';
    adresseController.text = proprietaire.adresse ?? '';
    pieceIdentiteController.text = proprietaire.pieceIdentite ?? '';
  }

  Future<void> updateProprietaire(int id) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final data = <String, dynamic>{
        'nom_complet': nomCompletController.text.trim(),
      };
      if (telephoneController.text.isNotEmpty) {
        data['telephone'] = telephoneController.text.trim();
      }
      if (emailController.text.isNotEmpty) {
        data['email'] = emailController.text.trim();
      }
      if (adresseController.text.isNotEmpty) {
        data['adresse'] = adresseController.text.trim();
      }
      if (pieceIdentiteController.text.isNotEmpty) {
        data['piece_identite'] = pieceIdentiteController.text.trim();
      }

      final result = await _service.updateProprietaire(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchProprietaires(refresh: true);
        Get.snackbar('Succès', 'Propriétaire modifié',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le propriétaire',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== SUPPRESSION ==========

  Future<void> deleteProprietaire(int id) async {
    try {
      final result = await _service.deleteProprietaire(id);
      if (result.success) {
        proprietairesList.removeWhere((p) => p.id == id);
        Get.snackbar('Succès', 'Propriétaire supprimé',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void confirmDelete(int id, String nom) {
    Get.defaultDialog(
      title: 'Confirmer la suppression',
      middleText:
          'Voulez-vous vraiment supprimer "$nom" ?',
      textCancel: 'Annuler',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        deleteProprietaire(id);
      },
    );
  }

  void _clearForm() {
    nomCompletController.clear();
    telephoneController.clear();
    emailController.clear();
    adresseController.clear();
    pieceIdentiteController.clear();
  }
}