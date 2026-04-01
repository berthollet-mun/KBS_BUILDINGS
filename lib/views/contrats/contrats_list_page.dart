import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/contrat_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class ContratsListPage extends StatelessWidget {
  const ContratsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ContratController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contrats de Bail'),
        actions: [
          IconButton(onPressed: () => Get.toNamed('/contrat-create'), icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          // Filtres statut
          SizedBox(
            height: 44,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  children: [
                    _chip('Tous', ctrl.selectedStatut.value == null, () => ctrl.filterByStatut(null)),
                    _chip('Actifs', ctrl.selectedStatut.value == 'actif', () => ctrl.filterByStatut('actif')),
                    _chip('Expirés', ctrl.selectedStatut.value == 'expire', () => ctrl.filterByStatut('expire')),
                    _chip('Résiliés', ctrl.selectedStatut.value == 'resilie', () => ctrl.filterByStatut('resilie')),
                  ],
                )),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.contratsList.isEmpty) return const LoadingWidget();
              if (ctrl.contratsList.isEmpty) return const EmptyState(icon: Icons.description_outlined, title: 'Aucun contrat', subtitle: 'Créez votre premier contrat de bail');
              return RefreshIndicator(
                onRefresh: () => ctrl.fetchContrats(refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.contratsList.length,
                  itemBuilder: (_, i) {
                    final c = ctrl.contratsList[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(c.numeroContrat ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                StatusBadge(label: c.statut.toUpperCase() ?? '', color: AppTheme.getStatutContratColor(c.statut)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(children: [
                              const Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(child: Text(c.locataireNom ?? '-', style: const TextStyle(fontSize: 14))),
                            ]),
                            const SizedBox(height: 6),
                            Row(children: [
                              const Icon(Icons.apartment, size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(child: Text('${c.codeBien ?? ''} - ${c.titreBien ?? ''}', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary))),
                            ]),
                            const SizedBox(height: 6),
                            Row(children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 6),
                              Text('${c.dateDebut ?? ''} → ${c.dateFin ?? ''}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                            ]),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${c.montantLoyer.toStringAsFixed(0) ?? '0'} USD/mois', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                TextButton(onPressed: () => Get.toNamed('/contrat-detail', arguments: c.id), child: const Text('Voir détails →')),
                              ],
                            ),
                          ],
                        ),
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

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.primaryColor)),
        ),
      ),
    );
  }
}