import 'package:get/get.dart';
import '../../data/models/contrat_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class ContratService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/contrats
  Future<ApiResult> getContrats({
    int page = 1,
    int perPage = 20,
    String? statut,
    int? bienId,
    int? locataireId,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (statut != null) params['statut'] = statut;
    if (bienId != null) params['bien_id'] = bienId.toString();
    if (locataireId != null) {
      params['locataire_id'] = locataireId.toString();
    }

    return await _api.get('/contrats', queryParams: params);
  }

  /// GET /api/contrats/{id}
  Future<ApiResult> getContrat(int id) async {
    return await _api.get('/contrats/$id');
  }

  /// POST /api/contrats
  Future<ApiResult> createContrat({
    required int bienId,
    required int locataireId,
    required String dateDebut,
    required String dateFin,
    required double montantLoyer,
    double? caution,
    String periodicite = 'mensuel',
  }) async {
    final body = <String, dynamic>{
      'bien_id': bienId,
      'locataire_id': locataireId,
      'date_debut': dateDebut,
      'date_fin': dateFin,
      'montant_loyer': montantLoyer,
      'periodicite': periodicite,
    };
    if (caution != null) body['caution'] = caution;

    return await _api.post('/contrats', body: body);
  }

  /// PUT /api/contrats/{id}
  Future<ApiResult> updateContrat(int id, Map<String, dynamic> data) async {
    return await _api.put('/contrats/$id', body: data);
  }

  /// Parse un contrat
  ContratModel? parseContrat(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return ContratModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<ContratModel> parsePaginatedContrats(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => ContratModel.fromJson(json),
    );
  }
}