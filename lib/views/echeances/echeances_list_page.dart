import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/echeance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class EcheancesListPage extends StatelessWidget {
  const EcheancesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(EcheanceController());
    return Scaffold(
      appBar: AppBar(title: const Text('Échéances'), actions: [
        IconButton(onPressed: () => ctrl.verifierRetards(), icon: const Icon(Icons.refresh), tooltip: 'Vérifier retards'),
      ]),
      body: Column(children: [
        SizedBox(height: 44, child: Obx(() => ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), children: [
          _chip('Toutes', ctrl.selectedStatut.value == null, () => ctrl.filterByStatut(null)),
          _chip('À venir', ctrl.selectedStatut.value == 'a_venir', () => ctrl.filterByStatut('a_venir')),
          _chip('Payées', ctrl.selectedStatut.value == 'payee', () => ctrl.filterByStatut('payee')),
          _chip('En retard', ctrl.selectedStatut.value == 'en_retard', () => ctrl.filterByStatut('en_retard')),
          _chip('Partielles', ctrl.selectedStatut.value == 'partielle', () => ctrl.filterByStatut('partielle')),
        ]))),
        Expanded(child: Obx(() {
          if (ctrl.isLoading.value && ctrl.echeancesList.isEmpty) return const LoadingWidget();
          if (ctrl.echeancesList.isEmpty) return const EmptyState(icon: Icons.event_note, title: 'Aucune échéance');
          return RefreshIndicator(onRefresh: () => ctrl.fetchEcheances(refresh: true), child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.echeancesList.length, itemBuilder: (_, i) {
            final e = ctrl.echeancesList[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: AppTheme.getStatutEcheanceColor(e.statut), width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.dateEcheance ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Attendu: ${e.montantAttendu?.toStringAsFixed(0) ?? '0'} USD', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  if (e.montantPaye != null && e.montantPaye! > 0) Text('Payé: ${e.montantPaye?.toStringAsFixed(0)} USD', style: const TextStyle(fontSize: 13, color: AppTheme.successColor)),
                ])),
                StatusBadge(label: AppTheme.getStatutEcheanceLabel(e.statut), color: AppTheme.getStatutEcheanceColor(e.statut)),
              ]),
            );
          }));
        })),
      ]),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: selected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.primaryColor)))));
  }
}