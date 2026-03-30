import 'package:get/get.dart';
import '../../data/models/maintenance_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class MaintenanceService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/maintenances
  Future<ApiResult> getMaintenances({
    int page = 1,
    int perPage = 20,
    String? statut,
    String? priorite,
    int? bienId,
    int? technicienId,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (statut != null) params['statut'] = statut;
    if (priorite != null) params['priorite'] = priorite;
    if (bienId != null) params['bien_id'] = bienId.toString();
    if (technicienId != null) {
      params['technicien_id'] = technicienId.toString();
    }

    return await _api.get('/maintenances', queryParams: params);
  }

  /// GET /api/maintenances/{id}
  Future<ApiResult> getMaintenance(int id) async {
    return await _api.get('/maintenances/$id');
  }

  /// POST /api/maintenances
  Future<ApiResult> createMaintenance({
    required int bienId,
    int? locataireId,
    required String titre,
    String? description,
    String? typePanne,
    String priorite = 'moyenne',
    int? technicienId,
  }) async {
    final body = <String, dynamic>{
      'bien_id': bienId,
      'titre': titre,
      'priorite': priorite,
    };
    if (locataireId != null) body['locataire_id'] = locataireId;
    if (description != null) body['description'] = description;
    if (typePanne != null) body['type_panne'] = typePanne;
    if (technicienId != null) body['technicien_id'] = technicienId;

    return await _api.post('/maintenances', body: body);
  }

  /// PUT /api/maintenances/{id}
  Future<ApiResult> updateMaintenance(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/maintenances/$id', body: data);
  }

  /// Parse une maintenance
  MaintenanceModel? parseMaintenance(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return MaintenanceModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<MaintenanceModel> parsePaginatedMaintenances(
    ApiResult result,
  ) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => MaintenanceModel.fromJson(json),
    );
  }
}