// lib/app/controllers/contrat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/contrat_service.dart';
import '../../data/models/contrat_model.dart';
import '../../data/responses/paginated_response.dart';

class ContratController extends GetxController {
  final ContratService _service = Get.find<ContratService>();

  // --- État liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<ContratModel> contratsList = <ContratModel>[].obs;

  // --- État détail ---
  final isDetailLoading = false.obs;
  final Rx<ContratModel?> selectedContrat = Rx<ContratModel?>(null);
  final detailError = ''.obs;

  // --- Sauvegarde ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final selectedStatut = Rx<String?>(null);
  final selectedBienId = Rx<int?>(null);
  final selectedLocataireId = Rx<int?>(null);

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  final formBienId = Rx<int?>(null);
  final formLocataireId = Rx<int?>(null);
  late TextEditingController dateDebutController;
  late TextEditingController dateFinController;
  late TextEditingController montantLoyerController;
  late TextEditingController cautionController;
  final formPeriodicite = 'mensuel'.obs;

  final List<String> periodicites = [
    'mensuel',
    'trimestriel',
    'semestriel',
    'annuel'
  ];
  final List<String> statutsContrat = ['actif', 'expire', 'resilie'];

  @override
  void onInit() {
    super.onInit();
    dateDebutController = TextEditingController();
    dateFinController = TextEditingController();
    montantLoyerController = TextEditingController();
    cautionController = TextEditingController();
    fetchContrats();
  }

  @override
  void onClose() {
    dateDebutController.dispose();
    dateFinController.dispose();
    montantLoyerController.dispose();
    cautionController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchContrats({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      contratsList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getContrats(
        page: _currentPage,
        statut: selectedStatut.value,
        bienId: selectedBienId.value,
        locataireId: selectedLocataireId.value,
      );

      if (result.success) {
        final PaginatedResponse<ContratModel> response =
            _service.parsePaginatedContrats(result);
        contratsList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des contrats.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreContrats() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _service.getContrats(
        page: _currentPage,
        statut: selectedStatut.value,
        bienId: selectedBienId.value,
        locataireId: selectedLocataireId.value,
      );

      if (result.success) {
        final PaginatedResponse<ContratModel> response =
            _service.parsePaginatedContrats(result);
        contratsList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  // ========== DÉTAIL ==========

  Future<void> fetchContratDetails(int id) async {
    isDetailLoading.value = true;
    selectedContrat.value = null;
    detailError.value = '';

    try {
      final result = await _service.getContrat(id);
      if (result.success) {
        selectedContrat.value = _service.parseContrat(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value =
          "Erreur de chargement des détails du contrat.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createContrat() async {
    if (!formKey.currentState!.validate()) return;
    if (formBienId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un bien',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (formLocataireId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un locataire',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _service.createContrat(
        bienId: formBienId.value!,
        locataireId: formLocataireId.value!,
        dateDebut: dateDebutController.text.trim(),
        dateFin: dateFinController.text.trim(),
        montantLoyer:
            double.parse(montantLoyerController.text.trim()),
        caution: cautionController.text.isNotEmpty
            ? double.tryParse(cautionController.text.trim())
            : null,
        periodicite: formPeriodicite.value,
      );

      if (result.success) {
        _clearForm();
        Get.back();
        fetchContrats(refresh: true);
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
      Get.snackbar('Erreur', 'Impossible de créer le contrat',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MODIFICATION ==========

  void fillForm(ContratModel contrat) {
    formBienId.value = contrat.bienId;
    formLocataireId.value = contrat.locataireId;
    dateDebutController.text = contrat.dateDebut ?? '';
    dateFinController.text = contrat.dateFin ?? '';
    montantLoyerController.text =
        contrat.montantLoyer.toString() ?? '';
    cautionController.text = contrat.caution?.toString() ?? '';
    formPeriodicite.value = contrat.periodicite ?? 'mensuel';
  }

  Future<void> updateContrat(int id) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final data = <String, dynamic>{};
      if (montantLoyerController.text.isNotEmpty) {
        data['montant_loyer'] =
            double.tryParse(montantLoyerController.text.trim());
      }
      if (cautionController.text.isNotEmpty) {
        data['caution'] =
            double.tryParse(cautionController.text.trim());
      }
      if (dateFinController.text.isNotEmpty) {
        data['date_fin'] = dateFinController.text.trim();
      }

      final result = await _service.updateContrat(id, data);

      if (result.success) {
        _clearForm();
        Get.back();
        fetchContrats(refresh: true);
        Get.snackbar('Succès', 'Contrat modifié',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le contrat',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Résilier un contrat
  Future<void> resilierContrat(int id) async {
    isSaving.value = true;
    try {
      final result = await _service.updateContrat(id, {
        'statut': 'resilie',
      });

      if (result.success) {
        fetchContrats(refresh: true);
        Get.snackbar('Succès', 'Contrat résilié',
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de résilier le contrat',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  void confirmResiliation(int id, String numero) {
    Get.defaultDialog(
      title: 'Résilier le contrat',
      middleText:
          'Voulez-vous vraiment résilier le contrat "$numero" ? Le bien sera remis en disponible.',
      textCancel: 'Annuler',
      textConfirm: 'Résilier',
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange,
      onConfirm: () {
        Get.back();
        resilierContrat(id);
      },
    );
  }

  // ========== FILTRES ==========

  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchContrats(refresh: true);
  }

  void filterByBien(int? bienId) {
    selectedBienId.value = bienId;
    fetchContrats(refresh: true);
  }

  void filterByLocataire(int? locataireId) {
    selectedLocataireId.value = locataireId;
    fetchContrats(refresh: true);
  }

  void clearFilters() {
    selectedStatut.value = null;
    selectedBienId.value = null;
    selectedLocataireId.value = null;
    fetchContrats(refresh: true);
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
    formBienId.value = null;
    formLocataireId.value = null;
    dateDebutController.clear();
    dateFinController.clear();
    montantLoyerController.clear();
    cautionController.clear();
    formPeriodicite.value = 'mensuel';
  }
}