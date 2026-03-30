import 'package:get/get.dart';
import '../../data/models/role_model.dart';
import 'api_service.dart';

class RoleService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/roles
  Future<ApiResult> getRoles() async {
    return await _api.get('/roles');
  }

  /// POST /api/roles
  Future<ApiResult> createRole({
    required String nom,
    String? description,
  }) async {
    return await _api.post('/roles', body: {
      'nom': nom,
      'description': description,
    });
  }

  /// Parse la liste des rôles depuis le résultat
  List<RoleModel> parseRoles(ApiResult result) {
    if (!result.success || result.responseData == null) return [];
    return (result.responseData as List)
        .map((e) => RoleModel.fromJson(e))
        .toList();
  }
}