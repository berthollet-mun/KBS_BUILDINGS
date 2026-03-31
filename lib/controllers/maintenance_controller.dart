// lib/app/controllers/maintenance_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/maintenance_service.dart';
import '../../data/models/maintenance_model.dart';
import '../../data/responses/paginated_response.dart';

class MaintenanceController extends GetxController {
  final MaintenanceService _service = Get.find<MaintenanceService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<MaintenanceModel> maintenancesList =
      <MaintenanceModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<MaintenanceModel?> selectedMaintenance =
      Rx<MaintenanceModel?>(null);
  final detailError = ''.obs;

  // --- Sauvegarde ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final selectedStatut = Rx<String?>(null);
  final selectedPriorite = Rx<String?>(null);
  final selectedBienId = Rx<int?>(null);
  final selectedTechnicienId = Rx<int?>(null);

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  final formBienId = Rx<int?>(null);
  final formLocataireId = Rx<int?>(null);
  final formTechnicienId = Rx<int?>(null);
  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController typePanneController;
  late TextEditingController coutController;
  late TextEditingController compteRenduController;
  final formPriorite = 'moyenne'.obs;
  final formStatut = 'en_attente'.obs;

  final List<String> priorites = [
    'faible',
    'moyenne',
    'haute',
    'urgente'
  ];
  final List<String> statuts = [
    'en_attente',
    'assignee',
    'en_cours',
    'terminee',
    'annulee'
  ];

  @override
  void onInit() {
    super.onInit();
    titreController = TextEditingController();
    descriptionController = TextEditingController();
    typePanneController = TextEditingController();
    coutController = TextEditingController();
    compteRenduController = TextEditingController();
    fetchMaintenances();
  }

  @override
  void onClose() {
    titreController.dispose();
    descriptionController.dispose();
    typePanneController.dispose();
    coutController.dispose();
    compteRenduController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchMaintenances({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      maintenancesList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getMaintenances(
        page: _currentPage,
        statut: selectedStatut.value,
        priorite: selectedPriorite.value,
        bienId: selectedBienId.value,
        technicienId: selectedTechnicienId.value,
      );

      if (result.success) {
        final PaginatedResponse<MaintenanceModel> response =
            _service.parsePaginatedMaintenances(result);
        maintenancesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des maintenances.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreMaintenances() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getMaintenances(
        page: _currentPage,
        statut: selectedStatut.value,
        priorite: selectedPriorite.value,
        bienId: selectedBienId.value,
        technicienId: selectedTechnicienId.value,
      );

      if (result.success) {
        final PaginatedResponse<MaintenanceModel> response =
            _service.parsePaginatedMaintenances(result);
        maintenancesList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchMaintenanceDetails(int id) async {
    isDetailLoading.value = true;
    selectedMaintenance.value = null;
    detailError.value = '';

    try {
      final result = await _service.getMaintenance(id);
      if (result.success) {
        selectedMaintenance.value =
            _service.parseMaintenance(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails de l'intervention.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createMaintenance() async {
    if (!formKey.currentState!.validate()) return;
    if (formBienId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un bien',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _service.createMaintenance(
        bienId: formBienId.value!,
        locataireId: formLocataireId.value,
        titre: titreController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        typePanne: typePanneController.text.trim().isEmpty
            ? null
            : typePanneController.text.trim(),
        priorite: formPriorite.value,
        technicienId: formTechnicienId.value,
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Ticket de maintenance créé',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Impossible de créer le ticket de maintenance',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MISE À JOUR ==========

  void fillForm(MaintenanceModel maintenance) {
    formBienId.value = maintenance.bienId;
    formTechnicienId.value = maintenance.technicienId;
    titreController.text = maintenance.titre ?? '';
    descriptionController.text = maintenance.description ?? '';
    typePanneController.text = maintenance.typePanne ?? '';
    coutController.text = maintenance.cout?.toString() ?? '';
    compteRenduController.text = maintenance.compteRendu ?? '';
    formPriorite.value = maintenance.priorite ?? 'moyenne';
    formStatut.value = maintenance.statut ?? 'en_attente';
  }

  Future<void> updateMaintenance(int id) async {
    isSaving.value = true;

    try {
      final data = <String, dynamic>{
        'statut': formStatut.value,
      };

      if (formTechnicienId.value != null) {
        data['technicien_id'] = formTechnicienId.value;
      }
      if (coutController.text.isNotEmpty) {
        data['cout'] = double.tryParse(coutController.text.trim());
      }
      if (compteRenduController.text.isNotEmpty) {
        data['compte_rendu'] = compteRenduController.text.trim();
      }
      if (formPriorite.value.isNotEmpty) {
        data['priorite'] = formPriorite.value;
      }

      final result = await _service.updateMaintenance(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Intervention mise à jour',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Impossible de mettre à jour l\'intervention',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Assigner un technicien
  Future<void> assignerTechnicien(int maintenanceId, int technicienId) async {
    isSaving.value = true;
    try {
      final result = await _service.updateMaintenance(maintenanceId, {
        'technicien_id': technicienId,
        'statut': 'assignee',
      });
      if (result.success) {
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Technicien assigné',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Démarrer l'intervention
  Future<void> demarrerIntervention(int id) async {
    isSaving.value = true;
    try {
      final result = await _service.updateMaintenance(id, {
        'statut': 'en_cours',
      });
      if (result.success) {
        fetchMaintenanceDetails(id);
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Intervention démarrée',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Terminer l'intervention
  Future<void> terminerIntervention(int id) async {
    if (coutController.text.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez renseigner le coût',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;
    try {
      final result = await _service.updateMaintenance(id, {
        'statut': 'terminee',
        'cout': double.tryParse(coutController.text.trim()) ?? 0,
        'compte_rendu': compteRenduController.text.trim(),
      });
      if (result.success) {
        _clearForm();
        fetchMaintenanceDetails(id);
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Intervention terminée',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Annuler l'intervention
  Future<void> annulerIntervention(int id) async {
    isSaving.value = true;
    try {
      final result = await _service.updateMaintenance(id, {
        'statut': 'annulee',
      });
      if (result.success) {
        fetchMaintenances(refresh: true);
        Get.snackbar('Succès', 'Intervention annulée',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } finally {
      isSaving.value = false;
    }
  }

  // ========== FILTRES ==========

  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchMaintenances(refresh: true);
  }

  void filterByPriorite(String? priorite) {
    selectedPriorite.value = priorite;
    fetchMaintenances(refresh: true);
  }

  void filterByBien(int? bienId) {
    selectedBienId.value = bienId;
    fetchMaintenances(refresh: true);
  }

  void filterByTechnicien(int? technicienId) {
    selectedTechnicienId.value = technicienId;
    fetchMaintenances(refresh: true);
  }

  void clearFilters() {
    selectedStatut.value = null;
    selectedPriorite.value = null;
    selectedBienId.value = null;
    selectedTechnicienId.value = null;
    fetchMaintenances(refresh: true);
  }

  void _clearForm() {
    formBienId.value = null;
    formLocataireId.value = null;
    formTechnicienId.value = null;
    titreController.clear();
    descriptionController.clear();
    typePanneController.clear();
    coutController.clear();
    compteRenduController.clear();
    formPriorite.value = 'moyenne';
    formStatut.value = 'en_attente';
  }

  // --- Getters ---
  Color getPrioriteColor(String? priorite) {
    switch (priorite) {
      case 'urgente':
        return Colors.red;
      case 'haute':
        return Colors.orange;
      case 'moyenne':
        return Colors.blue;
      case 'faible':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color getStatutColor(String? statut) {
    switch (statut) {
      case 'en_attente':
        return Colors.orange;
      case 'assignee':
        return Colors.blue;
      case 'en_cours':
        return Colors.purple;
      case 'terminee':
        return Colors.green;
      case 'annulee':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}