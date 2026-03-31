// lib/app/controllers/paiement_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/paiement_service.dart';
import '../../data/models/paiement_model.dart';
import '../../data/responses/paginated_response.dart';

class PaiementController extends GetxController {
  final PaiementService _service = Get.find<PaiementService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<PaiementModel> paiementsList = <PaiementModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<PaiementModel?> selectedPaiement =
      Rx<PaiementModel?>(null);
  final detailError = ''.obs;

  // --- Sauvegarde ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final selectedContratId = Rx<int?>(null);
  final selectedStatut = Rx<String?>(null);
  final selectedModePaiement = Rx<String?>(null);
  final dateDebut = ''.obs;
  final dateFin = ''.obs;

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  final formContratId = Rx<int?>(null);
  final formEcheanceId = Rx<int?>(null);
  late TextEditingController montantController;
  late TextEditingController datePaiementController;
  late TextEditingController periodeConcerneeController;
  late TextEditingController commentaireController;
  final formModePaiement = 'cash'.obs;

  final List<String> modesPaiement = [
    'cash',
    'mobile_money',
    'banque'
  ];
  final List<String> statutsPaiement = [
    'valide',
    'en_attente',
    'annule'
  ];

  @override
  void onInit() {
    super.onInit();
    montantController = TextEditingController();
    datePaiementController = TextEditingController();
    periodeConcerneeController = TextEditingController();
    commentaireController = TextEditingController();
    fetchPaiements();
  }

  @override
  void onClose() {
    montantController.dispose();
    datePaiementController.dispose();
    periodeConcerneeController.dispose();
    commentaireController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchPaiements({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      paiementsList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getPaiements(
        page: _currentPage,
        contratId: selectedContratId.value,
        statut: selectedStatut.value,
        modePaiement: selectedModePaiement.value,
        dateDebut: dateDebut.value.isEmpty ? null : dateDebut.value,
        dateFin: dateFin.value.isEmpty ? null : dateFin.value,
      );

      if (result.success) {
        final PaginatedResponse<PaiementModel> response =
            _service.parsePaginatedPaiements(result);
        paiementsList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des paiements.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMorePaiements() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getPaiements(
        page: _currentPage,
        contratId: selectedContratId.value,
        statut: selectedStatut.value,
        modePaiement: selectedModePaiement.value,
        dateDebut: dateDebut.value.isEmpty ? null : dateDebut.value,
        dateFin: dateFin.value.isEmpty ? null : dateFin.value,
      );

      if (result.success) {
        final PaginatedResponse<PaiementModel> response =
            _service.parsePaginatedPaiements(result);
        paiementsList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchPaiementDetails(int id) async {
    isDetailLoading.value = true;
    selectedPaiement.value = null;
    detailError.value = '';

    try {
      final result = await _service.getPaiement(id);
      if (result.success) {
        selectedPaiement.value = _service.parsePaiement(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails du paiement.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== ENREGISTREMENT ==========

  Future<void> createPaiement() async {
    if (!formKey.currentState!.validate()) return;
    if (formContratId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un contrat',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _service.createPaiement(
        contratId: formContratId.value!,
        echeanceId: formEcheanceId.value,
        montant: double.parse(montantController.text.trim()),
        modePaiement: formModePaiement.value,
        datePaiement: datePaiementController.text.trim().isEmpty
            ? null
            : datePaiementController.text.trim(),
        periodeConcernee:
            periodeConcerneeController.text.trim().isEmpty
                ? null
                : periodeConcerneeController.text.trim(),
        commentaire: commentaireController.text.trim().isEmpty
            ? null
            : commentaireController.text.trim(),
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchPaiements(refresh: true);
        Get.snackbar(
          'Succès',
          result.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'enregistrer le paiement',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== FILTRES ==========

  void filterByContrat(int? contratId) {
    selectedContratId.value = contratId;
    fetchPaiements(refresh: true);
  }

  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchPaiements(refresh: true);
  }

  void filterByMode(String? mode) {
    selectedModePaiement.value = mode;
    fetchPaiements(refresh: true);
  }

  void filterByDateRange(String debut, String fin) {
    dateDebut.value = debut;
    dateFin.value = fin;
    fetchPaiements(refresh: true);
  }

  void clearFilters() {
    selectedContratId.value = null;
    selectedStatut.value = null;
    selectedModePaiement.value = null;
    dateDebut.value = '';
    dateFin.value = '';
    fetchPaiements(refresh: true);
  }

  // ========== DATE PICKER ==========

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _clearForm() {
    formContratId.value = null;
    formEcheanceId.value = null;
    montantController.clear();
    datePaiementController.clear();
    periodeConcerneeController.clear();
    commentaireController.clear();
    formModePaiement.value = 'cash';
  }
}