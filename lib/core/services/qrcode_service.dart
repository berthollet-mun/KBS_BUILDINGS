import 'package:get/get.dart';
import '../../data/models/qrcode_model.dart';
import 'api_service.dart';

class QrCodeService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// POST /api/qrcodes/generate/{bien_id}
  Future<ApiResult> generateQrCode(int bienId) async {
    return await _api.post('/qrcodes/generate/$bienId');
  }

  /// GET /api/qrcodes/scan/{code} (PUBLIC)
  Future<ApiResult> scanQrCode(String code) async {
    return await _api.get('/qrcodes/scan/$code');
  }

  /// GET /api/qrcodes/bien/{bien_id} (PUBLIC)
  Future<ApiResult> getQrCodeByBien(int bienId) async {
    return await _api.get('/qrcodes/bien/$bienId');
  }

  /// Parse un QR Code
  QrCodeModel? parseQrCode(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return QrCodeModel.fromJson(result.responseData);
  }
}