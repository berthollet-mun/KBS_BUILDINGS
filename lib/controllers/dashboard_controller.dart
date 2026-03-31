import 'package:get/get.dart';
import '../core/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _service = Get.find<DashboardService>();

  final RxMap<String, dynamic> dashboard = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> stats = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getDashboard();

      if (!result.success) {
        error.value = result.message;
        return;
      }

      final data = result.responseData;
      if (data is Map) {
        dashboard.assignAll(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      error.value = 'Erreur chargement dashboard: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStats({
    String? dateDebut,
    String? dateFin,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getStats(
        dateDebut: dateDebut,
        dateFin: dateFin,
      );

      if (!result.success) {
        error.value = result.message;
        return;
      }

      final data = result.responseData;
      if (data is Map) {
        stats.assignAll(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      error.value = 'Erreur chargement stats: $e';
    } finally {
      isLoading.value = false;
    }
  }
}