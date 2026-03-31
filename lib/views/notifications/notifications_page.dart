import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/notification_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), actions: [
        Obx(() => ctrl.hasUnread ? TextButton(onPressed: ctrl.markAllAsRead, child: const Text('Tout lire', style: TextStyle(color: Colors.white))) : const SizedBox()),
      ]),
      body: Obx(() {
        if (ctrl.isLoading.value) return const LoadingWidget();
        if (ctrl.notificationsList.isEmpty) return const EmptyState(icon: Icons.notifications_off, title: 'Aucune notification', subtitle: 'Vous n\'avez pas de notification pour le moment');

        return RefreshIndicator(onRefresh: () => ctrl.fetchNotifications(), child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.notificationsList.length, itemBuilder: (_, i) {
          final n = ctrl.notificationsList[i];
          final isRead = n.dateLecture != null;
          return Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead ? Theme.of(context).cardColor : AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: isRead ? null : Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: InkWell(
              onTap: () => ctrl.markAsRead(n.id ?? 0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(_getNotifIcon(n.typeNotification), color: AppTheme.primaryColor, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n.sujet ?? '', style: TextStyle(fontWeight: isRead ? FontWeight.w400 : FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(n.message ?? '', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(n.createdAt ?? '', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                ])),
                if (!isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle)),
              ]),
            ),
          );
        }));
      }),
    );
  }

  IconData _getNotifIcon(String? type) {
    switch (type) {
      case 'echeance': return Icons.calendar_today;
      case 'paiement': return Icons.payments;
      case 'maintenance': return Icons.build;
      case 'contrat': return Icons.description;
      default: return Icons.notifications;
    }
  }
}