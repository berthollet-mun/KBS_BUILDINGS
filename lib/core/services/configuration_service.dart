import 'package:get/get.dart';
import '../../data/models/configuration_model.dart';
import 'api_service.dart';

class ConfigurationService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/configurations
  Future<ApiResult> getConfigurations() async {
    return await _api.get('/configurations');
  }

  /// PUT /api/configurations/{cle}
  Future<ApiResult> updateConfiguration(String cle, String valeur) async {
    return await _api.put('/configurations/$cle', body: {
      'valeur': valeur,
    });
  }

  /// Parse les configurations
  List<ConfigurationModel> parseConfigurations(ApiResult result) {
    if (!result.success || result.responseData == null) return [];
    if (result.responseData is List) {
      return (result.responseData as List)
          .map((e) => ConfigurationModel.fromJson(e))
          .toList();
    }
    return [];
  }
}