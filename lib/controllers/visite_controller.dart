// lib/app/controllers/visite_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/visite_service.dart';
import '../../data/models/visite_model.dart';
import '../../data/responses/paginated_response.dart';

class VisiteController extends GetxController {
  final VisiteService _service = Get.find<VisiteService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<VisiteModel> visitesList = <VisiteModel>[].obs;

  // --- Sauvegarde ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final selectedStatut = Rx<String?>(null);
  final selectedBienId = Rx<int?>(null);
  final selectedAgentId = Rx<int?>(null);

  // --- Formulaire (réservation publique) ---
  final formKey = GlobalKey<FormState>();
  final formBienId = Rx<int?>(null);
  late TextEditingController clientNomController;
  late TextEditingController clientTelephoneController;
  late TextEditingController clientEmailController;
  late TextEditingController dateVisiteController;
  late TextEditingController observationController;
  late TextEditingController noteSatisfactionController;
  final formStatut = 'planifiee'.obs;

  final List<String> statutsVisite = [
    'planifiee',
    'effectuee',
    'annulee',
    'reportee'
  ];

  @override
  void onInit() {
    super.onInit();
    clientNomController = TextEditingController();
    clientTelephoneController = TextEditingController();
    clientEmailController = TextEditingController();
    dateVisiteController = TextEditingController();
    observationController = TextEditingController();
    noteSatisfactionController = TextEditingController();
    fetchVisites();
  }

  @override
  void onClose() {
    clientNomController.dispose();
    clientTelephoneController.dispose();
    clientEmailController.dispose();
    dateVisiteController.dispose();
    observationController.dispose();
    noteSatisfactionController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchVisites({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      visitesList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getVisites(
        page: _currentPage,
        statut: selectedStatut.value,
        bienId: selectedBienId.value,
        agentId: selectedAgentId.value,
      );

      if (result.success) {
        final PaginatedResponse<VisiteModel> response =
            _service.parsePaginatedVisites(result);
        visitesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des visites.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreVisites() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getVisites(
        page: _currentPage,
        statut: selectedStatut.value,
        bienId: selectedBienId.value,
        agentId: selectedAgentId.value,
      );

      if (result.success) {
        final PaginatedResponse<VisiteModel> response =
            _service.parsePaginatedVisites(result);
        visitesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== RÉSERVATION (PUBLIC) ==========

  Future<void> reserverVisite() async {
    if (!formKey.currentState!.validate()) return;
    if (formBienId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un bien',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _service.reserverVisite(
        bienId: formBienId.value!,
        clientNom: clientNomController.text.trim(),
        clientTelephone: clientTelephoneController.text.trim(),
        clientEmail: clientEmailController.text.trim().isEmpty
            ? null
            : clientEmailController.text.trim(),
        dateVisite: dateVisiteController.text.trim(),
        observation: observationController.text.trim().isEmpty
            ? null
            : observationController.text.trim(),
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchVisites(refresh: true);
        Get.snackbar(
          'Succès',
          'Visite programmée avec succès !',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de réserver la visite',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MISE À JOUR ==========

  Future<void> updateVisite(int id) async {
    isSaving.value = true;

    try {
      final data = <String, dynamic>{
        'statut': formStatut.value,
      };

      if (observationController.text.isNotEmpty) {
        data['observation'] = observationController.text.trim();
      }
      if (noteSatisfactionController.text.isNotEmpty) {
        data['note_satisfaction'] =
            int.tryParse(noteSatisfactionController.text.trim());
      }

      final result = await _service.updateVisite(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchVisites(refresh: true);
        Get.snackbar('Succès', 'Visite mise à jour',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de mettre à jour la visite',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Marquer une visite comme effectuée
  Future<void> marquerEffectuee(int id) async {
    isSaving.value = true;
    try {
      final data = <String, dynamic>{
        'statut': 'effectuee',
      };
      if (observationController.text.isNotEmpty) {
        data['observation'] = observationController.text.trim();
      }
      if (noteSatisfactionController.text.isNotEmpty) {
        data['note_satisfaction'] =
            int.tryParse(noteSatisfactionController.text.trim());
      }

      final result = await _service.updateVisite(id, data);
      if (result.success) {
        fetchVisites(refresh: true);
        Get.snackbar('Succès', 'Visite marquée comme effectuée',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Annuler une visite
  Future<void> annulerVisite(int id) async {
    isSaving.value = true;
    try {
      final result = await _service.updateVisite(id, {
        'statut': 'annulee',
      });
      if (result.success) {
        fetchVisites(refresh: true);
        Get.snackbar('Succès', 'Visite annulée',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Reporter une visite
  Future<void> reporterVisite(int id, String nouvelleDate) async {
    isSaving.value = true;
    try {
      final result = await _service.updateVisite(id, {
        'statut': 'reportee',
        'date_visite': nouvelleDate,
      });
      if (result.success) {
        fetchVisites(refresh: true);
        Get.snackbar('Succès', 'Visite reportée',
            backgroundColor: Colors.blue, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  // ========== FILTRES ==========

  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchVisites(refresh: true);
  }

  void filterByBien(int? bienId) {
    selectedBienId.value = bienId;
    fetchVisites(refresh: true);
  }

  void filterByAgent(int? agentId) {
    selectedAgentId.value = agentId;
    fetchVisites(refresh: true);
  }

  void clearFilters() {
    selectedStatut.value = null;
    selectedBienId.value = null;
    selectedAgentId.value = null;
    fetchVisites(refresh: true);
  }

  // ========== DATE PICKER ==========

  Future<void> selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
      );
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        dateVisiteController.text =
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
      }
    }
  }

  void _clearForm() {
    formBienId.value = null;
    clientNomController.clear();
    clientTelephoneController.clear();
    clientEmailController.clear();
    dateVisiteController.clear();
    observationController.clear();
    noteSatisfactionController.clear();
    formStatut.value = 'planifiee';
  }

  // --- Getters ---
  Color getStatutColor(String? statut) {
    switch (statut) {
      case 'planifiee':
        return Colors.blue;
      case 'effectuee':
        return Colors.green;
      case 'annulee':
        return Colors.red;
      case 'reportee':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}