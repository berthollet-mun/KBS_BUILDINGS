import 'package:get/get.dart';
import '../core/services/proprietaire_service.dart';

class ProprietaireController extends GetxController {
  final ProprietaireService _service = Get.find<ProprietaireService>();

  final RxList<Map<String, dynamic>> proprietaires =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> currentProprietaire = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadProprietaires({
    int page = 1,
    String? search,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getProprietaires(
        page: page,
        perPage: 20,
        search: search,
      );

      if (!result.success) {
        error.value = result.message;
        return;
      }

      final data = result.responseData;
      if (data is List) {
        proprietaires.assignAll(
          data
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        );
      }
    } catch (e) {
      error.value = 'Erreur chargement propriétaires: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loadProprietaireDetail(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getProprietaire(id);

      if (!result.success) {
        error.value = result.message;
        return false;
      }

      final data = result.responseData;
      if (data is Map) {
        currentProprietaire.assignAll(Map<String, dynamic>.from(data));
        return true;
      }

      return false;
    } catch (e) {
      error.value = 'Erreur détail propriétaire: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}