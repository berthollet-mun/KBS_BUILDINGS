import 'package:get/get.dart';
import '../../data/models/paiement_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class PaiementService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/paiements
  Future<ApiResult> getPaiements({
    int page = 1,
    int perPage = 20,
    int? contratId,
    String? statut,
    String? modePaiement,
    String? dateDebut,
    String? dateFin,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (contratId != null) params['contrat_id'] = contratId.toString();
    if (statut != null) params['statut'] = statut;
    if (modePaiement != null) params['mode_paiement'] = modePaiement;
    if (dateDebut != null) params['date_debut'] = dateDebut;
    if (dateFin != null) params['date_fin'] = dateFin;

    return await _api.get('/paiements', queryParams: params);
  }

  /// GET /api/paiements/{id}
  Future<ApiResult> getPaiement(int id) async {
    return await _api.get('/paiements/$id');
  }

  /// POST /api/paiements
  Future<ApiResult> createPaiement({
    required int contratId,
    int? echeanceId,
    required double montant,
    required String modePaiement,
    String? datePaiement,
    String? periodeConcernee,
    String? commentaire,
  }) async {
    final body = <String, dynamic>{
      'contrat_id': contratId,
      'montant': montant,
      'mode_paiement': modePaiement,
    };
    if (echeanceId != null) body['echeance_id'] = echeanceId;
    if (datePaiement != null) body['date_paiement'] = datePaiement;
    if (periodeConcernee != null) {
      body['periode_concernee'] = periodeConcernee;
    }
    if (commentaire != null) body['commentaire'] = commentaire;

    return await _api.post('/paiements', body: body);
  }

  /// Parse un paiement
  PaiementModel? parsePaiement(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return PaiementModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<PaiementModel> parsePaginatedPaiements(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => PaiementModel.fromJson(json),
    );
  }
}