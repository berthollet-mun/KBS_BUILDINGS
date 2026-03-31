// lib/app/controllers/bien_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/bien_service.dart';
import '../../data/models/bien_model.dart';
import '../../data/responses/paginated_response.dart';

class BienController extends GetxController {
  final BienService _bienService = Get.find<BienService>();

  // --- État pour la liste ---
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final errorMessage = ''.obs;
  final RxList<BienModel> biensList = <BienModel>[].obs;

  // --- État pour le détail ---
  final isDetailLoading = false.obs;
  final Rx<BienModel?> selectedBien = Rx<BienModel?>(null);
  final detailError = ''.obs;

  // --- État pour la création/édition ---
  final isSaving = false.obs;

  // --- Pagination ---
  int _currentPage = 1;
  bool _hasMore = true;

  // --- Filtres ---
  final searchQuery = ''.obs;
  final selectedTypeBien = Rx<String?>(null);
  final selectedStatut = Rx<String?>(null);
  final selectedCommune = ''.obs;
  final selectedVille = ''.obs;
  final prixMin = Rx<double?>(null);
  final prixMax = Rx<double?>(null);
  final selectedProprietaireId = Rx<int?>(null);

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController adresseController;
  late TextEditingController communeController;
  late TextEditingController quartierController;
  late TextEditingController villeController;
  late TextEditingController surfaceController;
  late TextEditingController nbPiecesController;
  late TextEditingController etageController;
  late TextEditingController prixLoyerController;
  late TextEditingController prixVenteController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  final selectedFormTypeBien = 'maison'.obs;
  final selectedFormStatut = 'disponible'.obs;
  final isMeuble = false.obs;
  final formProprietaireId = Rx<int?>(null);

  // --- Types et statuts disponibles ---
  final List<String> typesBien = [
    'maison',
    'appartement',
    'parcelle',
    'bureau'
  ];
  final List<String> statutsBien = [
    'disponible',
    'occupe',
    'maintenance',
    'vendu',
    'reserve'
  ];

  @override
  void onInit() {
    super.onInit();
    _initFormControllers();
    fetchBiens();

    // Debounce sur la recherche
    debounce(searchQuery, (_) => fetchBiens(refresh: true),
        time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    _disposeFormControllers();
    super.onClose();
  }

  void _initFormControllers() {
    titreController = TextEditingController();
    descriptionController = TextEditingController();
    adresseController = TextEditingController();
    communeController = TextEditingController();
    quartierController = TextEditingController();
    villeController = TextEditingController();
    surfaceController = TextEditingController();
    nbPiecesController = TextEditingController();
    etageController = TextEditingController();
    prixLoyerController = TextEditingController();
    prixVenteController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  void _disposeFormControllers() {
    titreController.dispose();
    descriptionController.dispose();
    adresseController.dispose();
    communeController.dispose();
    quartierController.dispose();
    villeController.dispose();
    surfaceController.dispose();
    nbPiecesController.dispose();
    etageController.dispose();
    prixLoyerController.dispose();
    prixVenteController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }

  // ========== LISTE DES BIENS ==========

  /// Charge la liste des biens avec filtres
  Future<void> fetchBiens({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      biensList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _bienService.getBiens(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        typeBien: selectedTypeBien.value,
        statut: selectedStatut.value,
        commune:
            selectedCommune.value.isEmpty ? null : selectedCommune.value,
        ville: selectedVille.value.isEmpty ? null : selectedVille.value,
        prixMin: prixMin.value,
        prixMax: prixMax.value,
        proprietaireId: selectedProprietaireId.value,
      );

      if (result.success) {
        final PaginatedResponse<BienModel> response =
            _bienService.parsePaginatedBiens(result);
        biensList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value = "Erreur lors de la récupération des biens.";
    } finally {
      isLoading.value = false;
    }
  }

  /// Charger plus de biens (pagination infinie)
  Future<void> fetchMoreBiens() async {
    if (isLoading.value || isFetchingMore.value || !_hasMore) return;
    isFetchingMore.value = true;

    try {
      final result = await _bienService.getBiens(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        typeBien: selectedTypeBien.value,
        statut: selectedStatut.value,
        commune:
            selectedCommune.value.isEmpty ? null : selectedCommune.value,
        ville: selectedVille.value.isEmpty ? null : selectedVille.value,
        prixMin: prixMin.value,
        prixMax: prixMax.value,
        proprietaireId: selectedProprietaireId.value,
      );

      if (result.success) {
        final PaginatedResponse<BienModel> response =
            _bienService.parsePaginatedBiens(result);
        biensList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      }
    } finally {
      isFetchingMore.value = false;
    }
  }

  /// Biens disponibles (public)
  Future<void> fetchBiensDisponibles({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      biensList.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _bienService.getBiensDisponibles(
        page: _currentPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        typeBien: selectedTypeBien.value,
        commune:
            selectedCommune.value.isEmpty ? null : selectedCommune.value,
        ville: selectedVille.value.isEmpty ? null : selectedVille.value,
        prixMin: prixMin.value,
        prixMax: prixMax.value,
      );

      if (result.success) {
        final PaginatedResponse<BienModel> response =
            _bienService.parsePaginatedBiens(result);
        biensList.addAll(response.data);
        _hasMore = response.pagination.hasMore;
        if (_hasMore) _currentPage++;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value = "Erreur lors de la récupération des biens.";
    } finally {
      isLoading.value = false;
    }
  }

  // ========== DÉTAIL D'UN BIEN ==========

  /// Charge les détails d'un bien spécifique
  Future<void> fetchBienDetails(int id) async {
    isDetailLoading.value = true;
    selectedBien.value = null;
    detailError.value = '';

    try {
      final result = await _bienService.getBien(id);
      if (result.success) {
        selectedBien.value = _bienService.parseBien(result);
      } else {
        detailError.value = result.message;
      }
    } catch (e) {
      detailError.value = "Erreur de chargement des détails du bien.";
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ========== CRÉATION D'UN BIEN ==========

  /// Créer un nouveau bien
  Future<void> createBien() async {
    if (!formKey.currentState!.validate()) return;
    if (formProprietaireId.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un propriétaire',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSaving.value = true;

    try {
      final result = await _bienService.createBien(
        titre: titreController.text.trim(),
        typeBien: selectedFormTypeBien.value,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        adresse: adresseController.text.trim().isEmpty
            ? null
            : adresseController.text.trim(),
        commune: communeController.text.trim().isEmpty
            ? null
            : communeController.text.trim(),
        quartier: quartierController.text.trim().isEmpty
            ? null
            : quartierController.text.trim(),
        ville: villeController.text.trim().isEmpty
            ? null
            : villeController.text.trim(),
        surface: surfaceController.text.isNotEmpty
            ? double.tryParse(surfaceController.text)
            : null,
        nbPieces: nbPiecesController.text.isNotEmpty
            ? int.tryParse(nbPiecesController.text)
            : null,
        etage: etageController.text.isNotEmpty
            ? int.tryParse(etageController.text)
            : null,
        meuble: isMeuble.value ? 1 : 0,
        prixLoyer: prixLoyerController.text.isNotEmpty
            ? double.tryParse(prixLoyerController.text)
            : null,
        prixVente: prixVenteController.text.isNotEmpty
            ? double.tryParse(prixVenteController.text)
            : null,
        statut: selectedFormStatut.value,
        latitude: latitudeController.text.isNotEmpty
            ? double.tryParse(latitudeController.text)
            : null,
        longitude: longitudeController.text.isNotEmpty
            ? double.tryParse(longitudeController.text)
            : null,
        proprietaireId: formProprietaireId.value!,
      );

      if (result.success) {
        _clearBienForm();
        Get.back();
        fetchBiens(refresh: true);
        Get.snackbar(
          'Succès',
          'Bien créé avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le bien',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== MODIFICATION D'UN BIEN ==========

  /// Pré-remplir le formulaire pour l'édition
  void fillBienForm(BienModel bien) {
    titreController.text = bien.titre ?? '';
    descriptionController.text = bien.description ?? '';
    adresseController.text = bien.adresse ?? '';
    communeController.text = bien.commune ?? '';
    quartierController.text = bien.quartier ?? '';
    villeController.text = bien.ville ?? '';
    surfaceController.text = bien.surface?.toString() ?? '';
    nbPiecesController.text = bien.nbPieces?.toString() ?? '';
    etageController.text = bien.etage?.toString() ?? '';
    prixLoyerController.text = bien.prixLoyer?.toString() ?? '';
    prixVenteController.text = bien.prixVente?.toString() ?? '';
    latitudeController.text = bien.latitude?.toString() ?? '';
    longitudeController.text = bien.longitude?.toString() ?? '';
    selectedFormTypeBien.value = bien.typeBien ?? 'maison';
    selectedFormStatut.value = bien.statut ?? 'disponible';
    isMeuble.value = bien.meuble == 1;
    formProprietaireId.value = bien.proprietaireId;
  }

  /// Mettre à jour un bien existant
  Future<void> updateBien(int id) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final data = <String, dynamic>{
        'titre': titreController.text.trim(),
        'type_bien': selectedFormTypeBien.value,
        'statut': selectedFormStatut.value,
        'meuble': isMeuble.value ? 1 : 0,
      };

      if (descriptionController.text.isNotEmpty) {
        data['description'] = descriptionController.text.trim();
      }
      if (adresseController.text.isNotEmpty) {
        data['adresse'] = adresseController.text.trim();
      }
      if (communeController.text.isNotEmpty) {
        data['commune'] = communeController.text.trim();
      }
      if (quartierController.text.isNotEmpty) {
        data['quartier'] = quartierController.text.trim();
      }
      if (villeController.text.isNotEmpty) {
        data['ville'] = villeController.text.trim();
      }
      if (surfaceController.text.isNotEmpty) {
        data['surface'] = double.tryParse(surfaceController.text);
      }
      if (nbPiecesController.text.isNotEmpty) {
        data['nb_pieces'] = int.tryParse(nbPiecesController.text);
      }
      if (etageController.text.isNotEmpty) {
        data['etage'] = int.tryParse(etageController.text);
      }
      if (prixLoyerController.text.isNotEmpty) {
        data['prix_loyer'] = double.tryParse(prixLoyerController.text);
      }
      if (prixVenteController.text.isNotEmpty) {
        data['prix_vente'] = double.tryParse(prixVenteController.text);
      }
      if (latitudeController.text.isNotEmpty) {
        data['latitude'] = double.tryParse(latitudeController.text);
      }
      if (longitudeController.text.isNotEmpty) {
        data['longitude'] = double.tryParse(longitudeController.text);
      }
      if (formProprietaireId.value != null) {
        data['proprietaire_id'] = formProprietaireId.value;
      }

      final result = await _bienService.updateBien(id, data);

      if (result.success) {
        _clearBienForm();
        Get.back();
        fetchBiens(refresh: true);
        Get.snackbar(
          'Succès',
          'Bien modifié avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le bien',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // ========== SUPPRESSION ==========

  /// Supprimer un bien
  Future<void> deleteBien(int id) async {
    try {
      final result = await _bienService.deleteBien(id);
      if (result.success) {
        biensList.removeWhere((b) => b.id == id);
        if (selectedBien.value?.id == id) {
          selectedBien.value = null;
        }
        Get.snackbar(
          'Succès',
          'Bien supprimé',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer le bien',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Dialogue de confirmation de suppression
  void confirmDeleteBien(int id, String titre) {
    Get.defaultDialog(
      title: 'Confirmer la suppression',
      middleText:
          'Voulez-vous vraiment supprimer le bien "$titre" ?',
      textCancel: 'Annuler',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        deleteBien(id);
      },
    );
  }

  // ========== FILTRES ==========

  /// Appliquer un filtre par type
  void filterByType(String? type) {
    selectedTypeBien.value = type;
    fetchBiens(refresh: true);
  }

  /// Appliquer un filtre par statut
  void filterByStatut(String? statut) {
    selectedStatut.value = statut;
    fetchBiens(refresh: true);
  }

  /// Appliquer un filtre de prix
  void filterByPrice(double? min, double? max) {
    prixMin.value = min;
    prixMax.value = max;
    fetchBiens(refresh: true);
  }

  /// Réinitialiser tous les filtres
  void clearFilters() {
    searchQuery.value = '';
    selectedTypeBien.value = null;
    selectedStatut.value = null;
    selectedCommune.value = '';
    selectedVille.value = '';
    prixMin.value = null;
    prixMax.value = null;
    selectedProprietaireId.value = null;
    fetchBiens(refresh: true);
  }

  // --- Helpers ---
  void _clearBienForm() {
    titreController.clear();
    descriptionController.clear();
    adresseController.clear();
    communeController.clear();
    quartierController.clear();
    villeController.clear();
    surfaceController.clear();
    nbPiecesController.clear();
    etageController.clear();
    prixLoyerController.clear();
    prixVenteController.clear();
    latitudeController.clear();
    longitudeController.clear();
    selectedFormTypeBien.value = 'maison';
    selectedFormStatut.value = 'disponible';
    isMeuble.value = false;
    formProprietaireId.value = null;
  }
}