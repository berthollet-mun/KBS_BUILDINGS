import 'package:get/get.dart';
import '../../data/models/proprietaire_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class ProprietaireService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/proprietaires
  Future<ApiResult> getProprietaires({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) params['search'] = search;

    return await _api.get('/proprietaires', queryParams: params);
  }

  /// GET /api/proprietaires/{id}
  Future<ApiResult> getProprietaire(int id) async {
    return await _api.get('/proprietaires/$id');
  }

  /// POST /api/proprietaires
  Future<ApiResult> createProprietaire({
    required String nomComplet,
    String? telephone,
    String? email,
    String? adresse,
    String? pieceIdentite,
  }) async {
    final body = <String, dynamic>{
      'nom_complet': nomComplet,
    };
    if (telephone != null) body['telephone'] = telephone;
    if (email != null) body['email'] = email;
    if (adresse != null) body['adresse'] = adresse;
    if (pieceIdentite != null) body['piece_identite'] = pieceIdentite;

    return await _api.post('/proprietaires', body: body);
  }

  /// PUT /api/proprietaires/{id}
  Future<ApiResult> updateProprietaire(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/proprietaires/$id', body: data);
  }

  /// DELETE /api/proprietaires/{id}
  Future<ApiResult> deleteProprietaire(int id) async {
    return await _api.delete('/proprietaires/$id');
  }

  /// Parse un propriétaire
  ProprietaireModel? parseProprietaire(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return ProprietaireModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<ProprietaireModel> parsePaginatedProprietaires(
    ApiResult result,
  ) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => ProprietaireModel.fromJson(json),
    );
  }
}