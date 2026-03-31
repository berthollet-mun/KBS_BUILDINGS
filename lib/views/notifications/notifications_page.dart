import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
        Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: controller.markAllAsRead,
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty &&
            controller.notifications.isEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text('Aucune notification'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_active),
                  title: Text('${item['sujet'] ?? '-'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['message'] ?? '-'}'),
                      const SizedBox(height: 4),
                      Text('Statut: ${item['statut'] ?? '-'}'),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      final id = item['id'];
                      if (id != null) {
                        controller.markAsRead(id);
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}