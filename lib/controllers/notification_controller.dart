// lib/app/controllers/notification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/core/services/notification_service.dart';
import '../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  final NotificationAppService _service =
      Get.find<NotificationAppService>();

  // --- État ---
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxList<NotificationModel> notificationsList =
      <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  // ========== LISTE ==========

  Future<void> fetchNotifications({int limit = 50}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getNotifications(limit: limit);
      if (result.success) {
        notificationsList.value =
            _service.parseNotifications(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des notifications.";
    } finally {
      isLoading.value = false;
    }
  }

  // ========== COMPTEUR NON LUES ==========

  Future<void> fetchUnreadCount() async {
    try {
      final result = await _service.getUnreadCount();
      if (result.success) {
        unreadCount.value = _service.parseUnreadCount(result);
      }
    } catch (_) {
      // Silencieux
    }
  }

  // ========== MARQUER COMME LUE ==========

  Future<void> markAsRead(int id) async {
    try {
      final result = await _service.markAsRead(id);
      if (result.success) {
        // Met à jour localement
        final index =
            notificationsList.indexWhere((n) => n.id == id);
        if (index != -1) {
          // On force le refresh
          fetchNotifications();
        }
        fetchUnreadCount();
      }
    } catch (_) {
      // Silencieux
    }
  }

  // ========== MARQUER TOUTES COMME LUES ==========

  Future<void> markAllAsRead() async {
    try {
      final result = await _service.markAllAsRead();
      if (result.success) {
        unreadCount.value = 0;
        fetchNotifications();
        Get.snackbar(
          'Succès',
          'Toutes les notifications ont été marquées comme lues',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (_) {
      Get.snackbar('Erreur', 'Impossible de marquer comme lues',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- Getter ---
  bool get hasUnread => unreadCount.value > 0;
}