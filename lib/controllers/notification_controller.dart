import 'package:get/get.dart';
import '../core/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationAppService _service = Get.find<NotificationAppService>();

  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;
  final RxInt unreadCount = 0.obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    loadUnreadCount();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getNotifications(limit: 50);

      if (!result.success) {
        error.value = result.message;
        return;
      }

      final data = result.responseData;
      if (data is List) {
        notifications.assignAll(
          data
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        );
      }
    } catch (e) {
      error.value = 'Erreur notifications: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUnreadCount() async {
    try {
      final result = await _service.getUnreadCount();
      if (result.success && result.responseData is Map) {
        unreadCount.value = result.responseData['count'] ?? 0;
      }
    } catch (_) {}
  }

  Future<void> markAsRead(int id) async {
    final result = await _service.markAsRead(id);
    if (result.success) {
      await loadNotifications();
      await loadUnreadCount();
    }
  }

  Future<void> markAllAsRead() async {
    final result = await _service.markAllAsRead();
    if (result.success) {
      await loadNotifications();
      await loadUnreadCount();
    }
  }
}