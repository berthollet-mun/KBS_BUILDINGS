import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/proprietaire_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/custom_search_bar.dart';

class ProprietairesListPage extends StatelessWidget {
  const ProprietairesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProprietaireController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriétaires'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/proprietaire-create'),
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchBar(
              hint: 'Rechercher un propriétaire...',
              onChanged: (v) => ctrl.searchQuery.value = v,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.proprietairesList.isEmpty) {
                return const LoadingWidget(message: 'Chargement des propriétaires...');
              }
              if (ctrl.proprietairesList.isEmpty) {
                return EmptyState(
                  icon: Icons.person_off,
                  title: 'Aucun propriétaire',
                  subtitle: 'Ajoutez votre premier propriétaire',
                  buttonText: 'Ajouter',
                  onButtonPressed: () => Get.toNamed('/proprietaire-create'),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ctrl.fetchProprietaires(refresh: true),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      ctrl.fetchMoreProprietaires();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ctrl.proprietairesList.length +
                        (ctrl.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == ctrl.proprietairesList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final p = ctrl.proprietairesList[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            radius: 25,
                            child: Text(
                              p.nomComplet.substring(0, 1).toUpperCase() ?? '?',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: Text(
                            p.nomComplet ?? 'Sans nom',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (p.telephone != null)
                                Row(
                                  children: [
                                    const Icon(Icons.phone,
                                        size: 14, color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(p.telephone!,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.textSecondary)),
                                  ],
                                ),
                              if (p.email != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.email,
                                        size: 14, color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(p.email!,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: AppTheme.textSecondary),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  ctrl.fillForm(p);
                                  Get.toNamed('/proprietaire-edit',
                                      arguments: p.id);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 20, color: AppTheme.primaryColor),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: AppTheme.textSecondary),
                            ],
                          ),
                          onTap: () => Get.toNamed('/proprietaire-detail',
                              arguments: p.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}