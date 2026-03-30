import 'package:get/get.dart';
import '../../data/models/echeance_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class EcheanceService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/echeances
  Future<ApiResult> getEcheances({
    int page = 1,
    int perPage = 20,
    int? contratId,
    String? statut,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (contratId != null) params['contrat_id'] = contratId.toString();
    if (statut != null) params['statut'] = statut;

    return await _api.get('/echeances', queryParams: params);
  }

  /// GET /api/echeances/en-retard
  Future<ApiResult> getEcheancesEnRetard() async {
    return await _api.get('/echeances/en-retard');
  }

  /// GET /api/echeances/a-venir
  Future<ApiResult> getEcheancesAVenir({int jours = 7}) async {
    return await _api.get(
      '/echeances/a-venir',
      queryParams: {'jours': jours.toString()},
    );
  }

  /// POST /api/echeances/generer/{contrat_id}
  Future<ApiResult> genererEcheances(int contratId) async {
    return await _api.post('/echeances/generer/$contratId');
  }

  /// POST /api/echeances/verifier-retards
  Future<ApiResult> verifierRetards() async {
    return await _api.post('/echeances/verifier-retards');
  }

  /// Parse les échéances depuis une liste
  List<EcheanceModel> parseEcheances(ApiResult result) {
    if (!result.success || result.responseData == null) return [];
    if (result.responseData is List) {
      return (result.responseData as List)
          .map((e) => EcheanceModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Parse la liste paginée
  PaginatedResponse<EcheanceModel> parsePaginatedEcheances(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => EcheanceModel.fromJson(json),
    );
  }
}