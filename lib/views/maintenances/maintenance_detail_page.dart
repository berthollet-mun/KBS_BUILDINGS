import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/maintenance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class MaintenanceDetailPage extends StatelessWidget {
  const MaintenanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MaintenanceController>();
    ctrl.fetchMaintenanceDetails(Get.arguments ?? 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail Intervention')),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) return const LoadingWidget();
        final m = ctrl.selectedMaintenance.value;
        if (m == null) return const Center(child: Text('Non trouvé'));

        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(m.numeroTicket ?? '', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                Row(children: [
                  StatusBadge(label: AppTheme.getPrioriteLabel(m.priorite), color: ctrl.getPrioriteColor(m.priorite)),
                  const SizedBox(width: 6),
                  StatusBadge(label: AppTheme.getStatutMaintenanceLabel(m.statut), color: ctrl.getStatutColor(m.statut)),
                ]),
              ]),
              const SizedBox(height: 12),
              Text(m.titre ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (m.typePanne != null) ...[const SizedBox(height: 8), Row(children: [Icon(AppTheme.getTypePanneIcon(m.typePanne), size: 20, color: AppTheme.textSecondary), const SizedBox(width: 6), Text(m.typePanne!, style: const TextStyle(color: AppTheme.textSecondary))])],
            ])),
          const SizedBox(height: 20),

          if (m.description != null) ...[
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Description', style: AppTheme.headline3), const SizedBox(height: 12), Text(m.description!, style: const TextStyle(height: 1.6))])),
            const SizedBox(height: 20),
          ],

          if (m.compteRendu != null) ...[
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Compte rendu', style: AppTheme.headline3), const SizedBox(height: 12), Text(m.compteRendu!, style: const TextStyle(height: 1.6))])),
            const SizedBox(height: 20),
          ],

          if (m.cout != null)
            Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Coût intervention', style: AppTheme.headline3), Text('${m.cout?.toStringAsFixed(0)} USD', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))])),

          const SizedBox(height: 24),

          // Actions
          if (m.statut == 'en_attente' || m.statut == 'assignee')
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () => ctrl.demarrerIntervention(m.id ?? 0), icon: const Icon(Icons.play_arrow), label: const Text('Démarrer l\'intervention'))),
          if (m.statut == 'en_cours') ...[
            TextFormField(controller: ctrl.coutController, decoration: const InputDecoration(labelText: 'Coût (USD)'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextFormField(controller: ctrl.compteRenduController, decoration: const InputDecoration(labelText: 'Compte rendu'), maxLines: 3),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () => ctrl.terminerIntervention(m.id ?? 0), icon: const Icon(Icons.check), label: const Text('Terminer'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor))),
          ],
          const SizedBox(height: 40),
        ]));
      }),
    );
  }
}