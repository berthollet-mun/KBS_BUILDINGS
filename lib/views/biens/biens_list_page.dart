import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/bien_controller.dart';

class BiensListPage extends StatelessWidget {
  const BiensListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BienController controller = Get.put(BienController());
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des biens'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un bien...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () async {
                    await controller.applyFilters(
                      newSearch: searchController.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.biens.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.value.isNotEmpty &&
                  controller.biens.isEmpty) {
                return Center(child: Text(controller.error.value));
              }

              if (controller.biens.isEmpty) {
                return const Center(
                  child: Text('Aucun bien trouvé'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadBiens(),
                child: ListView.builder(
                  itemCount: controller.biens.length,
                  itemBuilder: (context, index) {
                    final bien = controller.biens[index];

                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.home_work),
                        ),
                        title: Text('${bien['titre'] ?? '-'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Code: ${bien['code_bien'] ?? '-'}'),
                            Text('Type: ${bien['type_bien'] ?? '-'}'),
                            Text('Statut: ${bien['statut'] ?? '-'}'),
                            Text('Loyer: ${bien['prix_loyer'] ?? 0} USD'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.bienDetail,
                            arguments: bien['id'],
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}