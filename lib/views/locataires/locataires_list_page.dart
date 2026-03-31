import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/locataire_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/custom_search_bar.dart';

class LocatairesListPage extends StatelessWidget {
  const LocatairesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LocataireController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locataires'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/locataire-create'),
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchBar(
              hint: 'Rechercher un locataire...',
              onChanged: (v) => ctrl.searchQuery.value = v,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.locatairesList.isEmpty) {
                return const LoadingWidget(message: 'Chargement des locataires...');
              }
              if (ctrl.locatairesList.isEmpty) {
                return EmptyState(
                  icon: Icons.people_outline,
                  title: 'Aucun locataire',
                  subtitle: 'Ajoutez votre premier locataire',
                  buttonText: 'Ajouter',
                  onButtonPressed: () => Get.toNamed('/locataire-create'),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ctrl.fetchLocataires(refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ctrl.locatairesList.length,
                  itemBuilder: (_, i) {
                    final l = ctrl.locatairesList[i];
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
                          backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                          radius: 25,
                          child: Text(
                            l.nomComplet?.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          l.nomComplet ?? 'Sans nom',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (l.telephone != null)
                              Row(children: [
                                const Icon(Icons.phone, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(l.telephone!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                              ]),
                            if (l.email != null) ...[
                              const SizedBox(height: 2),
                              Row(children: [
                                const Icon(Icons.email, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Expanded(child: Text(l.email!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                              ]),
                            ],
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                        onTap: () => Get.toNamed('/locataire-detail', arguments: l.id),
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