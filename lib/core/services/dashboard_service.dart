import 'package:get/get.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/dashboard_stats_model.dart';
import 'api_service.dart';

class DashboardService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/dashboard
  Future<ApiResult> getDashboard() async {
    return await _api.get('/dashboard');
  }

  /// GET /api/dashboard/stats
  Future<ApiResult> getStats({
    String? dateDebut,
    String? dateFin,
  }) async {
    final params = <String, String>{};
    if (dateDebut != null) params['date_debut'] = dateDebut;
    if (dateFin != null) params['date_fin'] = dateFin;

    return await _api.get('/dashboard/stats', queryParams: params);
  }

  /// Parse le dashboard
  DashboardModel? parseDashboard(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return DashboardModel.fromJson(result.responseData);
  }

  /// Parse les stats
  DashboardStatsModel? parseStats(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return DashboardStatsModel.fromJson(result.responseData);
  }
}