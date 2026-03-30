import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import 'api_service.dart';

class NotificationAppService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/notifications
  Future<ApiResult> getNotifications({int limit = 50}) async {
    return await _api.get(
      '/notifications',
      queryParams: {'limit': limit.toString()},
    );
  }

  /// GET /api/notifications/unread-count
  Future<ApiResult> getUnreadCount() async {
    return await _api.get('/notifications/unread-count');
  }

  /// PUT /api/notifications/{id}/read
  Future<ApiResult> markAsRead(int id) async {
    return await _api.put('/notifications/$id/read');
  }

  /// PUT /api/notifications/read-all
  Future<ApiResult> markAllAsRead() async {
    return await _api.put('/notifications/read-all');
  }

  /// Parse les notifications
  List<NotificationModel> parseNotifications(ApiResult result) {
    if (!result.success || result.responseData == null) return [];
    if (result.responseData is List) {
      return (result.responseData as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Parse le count non lu
  int parseUnreadCount(ApiResult result) {
    if (!result.success || result.responseData == null) return 0;
    return result.responseData['count'] ?? 0;
  }
}