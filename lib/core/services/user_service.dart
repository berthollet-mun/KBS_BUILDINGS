import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/responses/paginated_response.dart';
import 'api_service.dart';

class UserService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/users
  Future<ApiResult> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search != null && search.isNotEmpty) params['search'] = search;

    return await _api.get('/users', queryParams: params);
  }

  /// GET /api/users/{id}
  Future<ApiResult> getUser(int id) async {
    return await _api.get('/users/$id');
  }

  /// POST /api/users
  Future<ApiResult> createUser({
    required String nom,
    String? postnom,
    required String prenom,
    required String email,
    String? telephone,
    required String motDePasse,
    required int roleId,
    String statut = 'actif',
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'mot_de_passe': motDePasse,
      'role_id': roleId,
      'statut': statut,
    };
    if (postnom != null) body['postnom'] = postnom;
    if (telephone != null) body['telephone'] = telephone;

    return await _api.post('/users', body: body);
  }

  /// PUT /api/users/{id}
  Future<ApiResult> updateUser(int id, Map<String, dynamic> data) async {
    return await _api.put('/users/$id', body: data);
  }

  /// DELETE /api/users/{id}
  Future<ApiResult> deleteUser(int id) async {
    return await _api.delete('/users/$id');
  }

  /// Parse un utilisateur depuis le résultat
  UserModel? parseUser(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return UserModel.fromJson(result.responseData);
  }

  /// Parse la liste paginée
  PaginatedResponse<UserModel> parsePaginatedUsers(ApiResult result) {
    return PaginatedResponse.fromJson(
      result.data ?? {},
      (json) => UserModel.fromJson(json),
    );
  }
}