// lib/app/controllers/echeance_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/echeance_service.dart';
import '../../data/models/echeance_model.dart';
import '../../data/responses/paginated_response.dart';

class EcheanceController extends GetxController {
  final EcheanceService _service = Get.find<EcheanceService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<EcheanceModel> echeancesList = <EcheanceModel>[].obs;

  // --- État retards ---
  final isRetardsLoading = false.obs;
  final RxList<EcheanceModel> echeancesEnRetard =
      <EcheanceModel>[].obs;

  // --- État à venir ---
  final isAVenirLoading = false.obs;
  final RxList<EcheanceModel> echeancesAVenir =
      <EcheanceModel>[].obs;

  // --- Actions ---
  final isProcessing = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final selectedContratId = Rx<int?>(null);
  final selectedStatut = Rx<String?>(null);
  final joursAVenir = 7.obs;

  final List<String> statutsEcheance = [
    'a_venir',
    'payee',
    'en_retard',
    'partielle'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchEcheances();
  }

  // ========== LISTE ==========

  Future<void> fetchEcheances({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      echeancesList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getEcheances(
        page: _currentPage,
        contratId: selectedContratId.value,
        statut: selectedStatut.value,
      );

      if (result.success) {
        final PaginatedResponse<EcheanceModel> response =
            _service.parsePaginatedEcheances(result);
        echeancesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des échéances.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreEcheances() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getEcheances(
        page: _currentPage,
        contratId: selectedContratId.value,
        statut: selectedStatut.value,
      );

      if (result.success) {
        final PaginatedResponse<EcheanceModel> response =
            _service.parsePaginatedEcheances(result);
        echeancesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== ÉCHÉANCES EN RETARD ==========

  Future<void> fetchEcheancesEnRetard() async {
    isRetardsLoading.value = true;
    echeancesEnRetard.clear();

    try {
      final result = await _service.getEcheancesEnRetard();
      if (result.success) {
        echeancesEnRetard.value = _service.parseEcheances(result);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Impossible de charger les échéances en retard',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isRetardsLoading.value = false;
    }
  }

  // ========== ÉCHÉANCES À VENIR ==========

  Future<void> fetchEcheancesAVenir({int? jours}) async {
    isAVenirLoading.value = true;
    echeancesAVenir.clear();

    try {
      final result = await _service.getEcheancesAVenir(
        jours: jours ?? joursAVenir.value,
      );
      if (result.success) {
        echeancesAVenir.value = _service.parseEcheances(result);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Impossible de charger les échéances à venir',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isAVenirLoading.value = false;
    }
  }

  // ========== GÉNÉRER ÉCHÉANCES ==========

  Future<void> genererEcheances(int contratId) async {
    isProcessing.value = true;

    try {
      final result = await _service.genererEcheances(contratId);
      if (result.success) {
        Get.snackbar('Succès', result.message,
            backgroundColor: Colors.green, colorText: Colors.white);
        fetchEcheances(refresh: true);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de générer les échéances',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isProcessing.value = false;
    }
  }

  // ========== VÉRIFIER RETARDS ==========

  Future<void> verifierRetards() async {
    isProcessing.value = true;

    try {
      final result = await _service.verifierRetards();
      if (result.success) {
        Get.snackbar(
          'Succès',
          'Vérification des retards effectuée',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Recharger les données
        fetchEcheances(refresh: true);
        fetchEcheancesEnRetard();
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de vérifier les retards',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isProcessing.value = false;
    }
  }

  // ========== FILTRES ==========

  void filterByContrat(int? contratId) {
    selectedContratId.value = contratId;
    fetchEcheances(refresh: true);
  }

  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchEcheances(refresh: true);
  }

  void clearFilters() {
    selectedContratId.value = null;
    selectedStatut.value = null;
    fetchEcheances(refresh: true);
  }

  // --- Getters ---
  int get totalRetards => echeancesEnRetard.length;
  int get totalAVenir => echeancesAVenir.length;
}