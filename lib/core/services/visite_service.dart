import 'package:get/get.dart';
import '../../data/models/visite_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class VisiteService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/visites
  Future<ApiResult> getVisites({
    int page = 1,
    int perPage = 20,
    String? statut,
    int? bienId,
    int? agentId,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (statut != null) params['statut'] = statut;
    if (bienId != null) params['bien_id'] = bienId.toString();
    if (agentId != null) params['agent_id'] = agentId.toString();

    return await _api.get('/visites', queryParams: params);
  }

  /// POST /api/visites (PUBLIC)
  Future<ApiResult> reserverVisite({
    required int bienId,
    required String clientNom,
    required String clientTelephone,
    String? clientEmail,
    required String dateVisite,
    String? observation,
  }) async {
    final body = <String, dynamic>{
      'bien_id': bienId,
      'client_nom': clientNom,
      'client_telephone': clientTelephone,
      'date_visite': dateVisite,
    };
    if (clientEmail != null) body['client_email'] = clientEmail;
    if (observation != null) body['observation'] = observation;

    return await _api.post('/visites', body: body);
  }

  /// PUT /api/visites/{id}
  Future<ApiResult> updateVisite(int id, Map<String, dynamic> data) async {
    return await _api.put('/visites/$id', body: data);
  }

  /// Parse une visite
  VisiteModel? parseVisite(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return VisiteModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<VisiteModel> parsePaginatedVisites(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => VisiteModel.fromJson(json),
    );
  }
}