// lib/app/controllers/locataire_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/locataire_service.dart';
import '../../data/models/locataire_model.dart';
import '../../data/responses/paginated_response.dart';

class LocataireController extends GetxController {
  final LocataireService _service = Get.find<LocataireService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<LocataireModel> locatairesList = <LocataireModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<LocataireModel?> selectedLocataire =
      Rx<LocataireModel?>(null);
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
    fetchLocataires();

    debounce(searchQuery, (_) => fetchLocataires(refresh: true),
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

  Future<void> fetchLocataires({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      locatairesList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getLocataires(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<LocataireModel> response =
            _service.parsePaginatedLocataires(result);
        locatairesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des locataires.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreLocataires() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getLocataires(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (result.success) {
        final PaginatedResponse<LocataireModel> response =
            _service.parsePaginatedLocataires(result);
        locatairesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchLocataireDetails(int id) async {
    isDetailLoading.value = true;
    selectedLocataire.value = null;
    detailError.value = '';

    try {
      final result = await _service.getLocataire(id);
      if (result.success) {
        selectedLocataire.value = _service.parseLocataire(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails du locataire.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createLocataire() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final result = await _service.createLocataire(
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
        fetchLocataires(refresh: true);
        Get.snackbar('Succès', 'Locataire créé avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le locataire',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MODIFICATION ==========

  void fillForm(LocataireModel locataire) {
    nomCompletController.text = locataire.nomComplet ?? '';
    telephoneController.text = locataire.telephone ?? '';
    emailController.text = locataire.email ?? '';
    adresseController.text = locataire.adresse ?? '';
    pieceIdentiteController.text = locataire.pieceIdentite ?? '';
  }

  Future<void> updateLocataire(int id) async {
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

      final result = await _service.updateLocataire(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchLocataires(refresh: true);
        Get.snackbar('Succès', 'Locataire modifié',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le locataire',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== SUPPRESSION ==========

  Future<void> deleteLocataire(int id) async {
    try {
      final result = await _service.deleteLocataire(id);
      if (result.success) {
        locatairesList.removeWhere((l) => l.id == id);
        Get.snackbar('Succès', 'Locataire supprimé',
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
      middleText: 'Voulez-vous vraiment supprimer "$nom" ?',
      textCancel: 'Annuler',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        deleteLocataire(id);
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