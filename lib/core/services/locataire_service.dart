import 'package:get/get.dart';
import '../../data/models/locataire_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class LocataireService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/locataires
  Future<ApiResult> getLocataires({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) params['search'] = search;

    return await _api.get('/locataires', queryParams: params);
  }

  /// GET /api/locataires/{id}
  Future<ApiResult> getLocataire(int id) async {
    return await _api.get('/locataires/$id');
  }

  /// POST /api/locataires
  Future<ApiResult> createLocataire({
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

    return await _api.post('/locataires', body: body);
  }

  /// PUT /api/locataires/{id}
  Future<ApiResult> updateLocataire(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _api.put('/locataires/$id', body: data);
  }

  /// DELETE /api/locataires/{id}
  Future<ApiResult> deleteLocataire(int id) async {
    return await _api.delete('/locataires/$id');
  }

  /// Parse un locataire
  LocataireModel? parseLocataire(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return LocataireModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<LocataireModel> parsePaginatedLocataires(
    ApiResult result,
  ) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => LocataireModel.fromJson(json),
    );
  }
}