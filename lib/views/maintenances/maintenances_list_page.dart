import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/maintenance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class MaintenancesListPage extends StatelessWidget {
  const MaintenancesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MaintenanceController());

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance & Pannes'), actions: [
        IconButton(onPressed: () => Get.toNamed('/maintenance-create'), icon: const Icon(Icons.add)),
      ]),
      body: Column(children: [
        // Stats rapides
        Obx(() => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                _statBadge('En attente', '${ctrl.maintenancesList.where((m) => m.statut == 'en_attente').length}', AppTheme.warningColor),
                const SizedBox(width: 8),
                _statBadge('En cours', '${ctrl.maintenancesList.where((m) => m.statut == 'en_cours').length}', AppTheme.infoColor),
                const SizedBox(width: 8),
                _statBadge('Terminés', '${ctrl.maintenancesList.where((m) => m.statut == 'terminee').length}', AppTheme.successColor),
              ]),
            )),
        // Filtres
        SizedBox(height: 44, child: Obx(() => ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
          _chip('Tous', ctrl.selectedStatut.value == null, () => ctrl.filterByStatut(null)),
          _chip('En attente', ctrl.selectedStatut.value == 'en_attente', () => ctrl.filterByStatut('en_attente')),
          _chip('En cours', ctrl.selectedStatut.value == 'en_cours', () => ctrl.filterByStatut('en_cours')),
          _chip('Terminés', ctrl.selectedStatut.value == 'terminee', () => ctrl.filterByStatut('terminee')),
        ]))),
        const SizedBox(height: 8),
        Expanded(child: Obx(() {
          if (ctrl.isLoading.value && ctrl.maintenancesList.isEmpty) return const LoadingWidget();
          if (ctrl.maintenancesList.isEmpty) return EmptyState(icon: Icons.build_outlined, title: 'Aucun ticket', buttonText: 'Nouveau ticket', onButtonPressed: () => Get.toNamed('/maintenance-create'));

          return RefreshIndicator(onRefresh: () => ctrl.fetchMaintenances(refresh: true), child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: ctrl.maintenancesList.length, itemBuilder: (_, i) {
            final m = ctrl.maintenancesList[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: ctrl.getPrioriteColor(m.priorite), width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(m.numeroTicket ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Row(children: [
                    StatusBadge(label: AppTheme.getPrioriteLabel(m.priorite), color: ctrl.getPrioriteColor(m.priorite)),
                    const SizedBox(width: 6),
                    StatusBadge(label: AppTheme.getStatutMaintenanceLabel(m.statut), color: ctrl.getStatutColor(m.statut)),
                  ]),
                ]),
                const SizedBox(height: 8),
                Text(m.titre ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                if (m.typePanne != null) Row(children: [
                  Icon(AppTheme.getTypePanneIcon(m.typePanne), size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Text(m.typePanne!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ]),
              ]),
            );
          }));
        })),
      ]),
    );
  }

  Widget _statBadge(String label, String count, Color color) {
    return Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Column(children: [
      Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.9))),
    ])));
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: selected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.primaryColor)))));
  }
}