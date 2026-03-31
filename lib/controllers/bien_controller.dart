import 'package:get/get.dart';
import '../core/services/bien_service.dart';

class BienController extends GetxController {
  final BienService _service = Get.find<BienService>();

  final RxList<Map<String, dynamic>> biens = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> currentBien = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;

  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxBool hasMore = false.obs;

  final RxString search = ''.obs;
  final RxString typeBien = ''.obs;
  final RxString statut = ''.obs;
  final RxString commune = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBiens();
  }

  Future<void> loadBiens({bool refresh = true}) async {
    try {
      if (refresh) {
        isLoading.value = true;
        currentPage.value = 1;
        biens.clear();
      } else {
        isLoadingMore.value = true;
      }

      error.value = '';

      final result = await _service.getBiens(
        page: currentPage.value,
        perPage: 20,
        search: search.value.isEmpty ? null : search.value,
        typeBien: typeBien.value.isEmpty ? null : typeBien.value,
        statut: statut.value.isEmpty ? null : statut.value,
        commune: commune.value.isEmpty ? null : commune.value,
      );

      if (!result.success) {
        error.value = result.message;
        return;
      }

      final data = result.responseData;
      if (data is List) {
        final items = data
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        if (refresh) {
          biens.assignAll(items);
        } else {
          biens.addAll(items);
        }
      }

      final pagination = result.pagination;
      if (pagination != null) {
        currentPage.value = pagination['current_page'] ?? 1;
        lastPage.value = pagination['last_page'] ?? 1;
        hasMore.value = pagination['has_more'] ?? false;
      }
    } catch (e) {
      error.value = 'Erreur de chargement des biens: $e';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    currentPage.value++;
    await loadBiens(refresh: false);
  }

  Future<bool> loadBienDetail(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getBien(id);

      if (!result.success) {
        error.value = result.message;
        return false;
      }

      final data = result.responseData;
      if (data is Map) {
        currentBien.assignAll(Map<String, dynamic>.from(data));
        return true;
      }

      error.value = 'Détail du bien invalide';
      return false;
    } catch (e) {
      error.value = 'Erreur détail bien: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBien(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.createBien(
        titre: payload['titre'],
        typeBien: payload['type_bien'],
        description: payload['description'],
        adresse: payload['adresse'],
        commune: payload['commune'],
        quartier: payload['quartier'],
        ville: payload['ville'],
        surface: payload['surface'],
        nbPieces: payload['nb_pieces'],
        etage: payload['etage'],
        meuble: payload['meuble'],
        prixLoyer: payload['prix_loyer'],
        prixVente: payload['prix_vente'],
        statut: payload['statut'] ?? 'disponible',
        latitude: payload['latitude'],
        longitude: payload['longitude'],
        proprietaireId: payload['proprietaire_id'],
      );

      if (!result.success) {
        error.value = result.message;
        return false;
      }

      await loadBiens();
      return true;
    } catch (e) {
      error.value = 'Erreur création bien: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilters({
    String? newSearch,
    String? newTypeBien,
    String? newStatut,
    String? newCommune,
  }) async {
    search.value = newSearch ?? search.value;
    typeBien.value = newTypeBien ?? typeBien.value;
    statut.value = newStatut ?? statut.value;
    commune.value = newCommune ?? commune.value;
    await loadBiens();
  }

  Future<void> clearFilters() async {
    search.value = '';
    typeBien.value = '';
    statut.value = '';
    commune.value = '';
    await loadBiens();
  }
}