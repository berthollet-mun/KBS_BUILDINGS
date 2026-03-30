import 'package:get/get.dart';
import '../../data/models/bien_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class BienService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/biens
  Future<ApiResult> getBiens({
    int page = 1,
    int perPage = 20,
    String? search,
    String? typeBien,
    String? statut,
    String? commune,
    String? ville,
    double? prixMin,
    double? prixMax,
    int? proprietaireId,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (typeBien != null) params['type_bien'] = typeBien;
    if (statut != null) params['statut'] = statut;
    if (commune != null) params['commune'] = commune;
    if (ville != null) params['ville'] = ville;
    if (prixMin != null) params['prix_min'] = prixMin.toString();
    if (prixMax != null) params['prix_max'] = prixMax.toString();
    if (proprietaireId != null) {
      params['proprietaire_id'] = proprietaireId.toString();
    }

    return await _api.get('/biens', queryParams: params);
  }

  /// GET /api/biens/disponibles (PUBLIC)
  Future<ApiResult> getBiensDisponibles({
    int page = 1,
    int perPage = 20,
    String? search,
    String? typeBien,
    String? commune,
    String? ville,
    double? prixMin,
    double? prixMax,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (typeBien != null) params['type_bien'] = typeBien;
    if (commune != null) params['commune'] = commune;
    if (ville != null) params['ville'] = ville;
    if (prixMin != null) params['prix_min'] = prixMin.toString();
    if (prixMax != null) params['prix_max'] = prixMax.toString();

    return await _api.get('/biens/disponibles', queryParams: params);
  }

  /// GET /api/biens/{id}
  Future<ApiResult> getBien(int id) async {
    return await _api.get('/biens/$id');
  }

  /// POST /api/biens
  Future<ApiResult> createBien({
    required String titre,
    required String typeBien,
    String? description,
    String? adresse,
    String? commune,
    String? quartier,
    String? ville,
    double? surface,
    int? nbPieces,
    int? etage,
    int? meuble,
    double? prixLoyer,
    double? prixVente,
    String statut = 'disponible',
    double? latitude,
    double? longitude,
    required int proprietaireId,
  }) async {
    final body = <String, dynamic>{
      'titre': titre,
      'type_bien': typeBien,
      'statut': statut,
      'proprietaire_id': proprietaireId,
    };
    if (description != null) body['description'] = description;
    if (adresse != null) body['adresse'] = adresse;
    if (commune != null) body['commune'] = commune;
    if (quartier != null) body['quartier'] = quartier;
    if (ville != null) body['ville'] = ville;
    if (surface != null) body['surface'] = surface;
    if (nbPieces != null) body['nb_pieces'] = nbPieces;
    if (etage != null) body['etage'] = etage;
    if (meuble != null) body['meuble'] = meuble;
    if (prixLoyer != null) body['prix_loyer'] = prixLoyer;
    if (prixVente != null) body['prix_vente'] = prixVente;
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;

    return await _api.post('/biens', body: body);
  }

  /// PUT /api/biens/{id}
  Future<ApiResult> updateBien(int id, Map<String, dynamic> data) async {
    return await _api.put('/biens/$id', body: data);
  }

  /// DELETE /api/biens/{id}
  Future<ApiResult> deleteBien(int id) async {
    return await _api.delete('/biens/$id');
  }

  /// Parse un bien
  BienModel? parseBien(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return BienModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<BienModel> parsePaginatedBiens(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => BienModel.fromJson(json),
    );
  }
}