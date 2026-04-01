import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/paiement_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class PaiementsListPage extends StatelessWidget {
  const PaiementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PaiementController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Loyers'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.toNamed('/paiement-create'), icon: const Icon(Icons.add)),
          IconButton(onPressed: () => Get.toNamed('/echeances-en-retard'), icon: const Icon(Icons.warning_amber)),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          SizedBox(
            height: 44,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  children: [
                    _chip('Tous', ctrl.selectedStatut.value == null, () => ctrl.filterByStatut(null)),
                    _chip('Validés', ctrl.selectedStatut.value == 'valide', () => ctrl.filterByStatut('valide')),
                    _chip('En attente', ctrl.selectedStatut.value == 'en_attente', () => ctrl.filterByStatut('en_attente')),
                    _chip('Annulés', ctrl.selectedStatut.value == 'annule', () => ctrl.filterByStatut('annule')),
                  ],
                )),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.paiementsList.isEmpty) return const LoadingWidget();
              if (ctrl.paiementsList.isEmpty) return EmptyState(icon: Icons.payments_outlined, title: 'Aucun paiement', buttonText: 'Ajouter un paiement', onButtonPressed: () => Get.toNamed('/paiement-create'));

              return RefreshIndicator(
                onRefresh: () => ctrl.fetchPaiements(refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.paiementsList.length,
                  itemBuilder: (_, i) {
                    final p = ctrl.paiementsList[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppTheme.successColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(AppTheme.getModePaiementIcon(p.modePaiement), color: AppTheme.successColor, size: 24),
                        ),
                        title: Text(p.referencePaiement ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 4),
                          Text(p.locataireNom ?? '', style: const TextStyle(fontSize: 13)),
                          Text('${p.datePaiement ?? ''} • ${AppTheme.getModePaiementLabel(p.modePaiement)}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ]),
                        trailing: Text('${p.montant.toStringAsFixed(0) ?? '0'}\nUSD', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.successColor, fontSize: 16)),
                        onTap: () => Get.toNamed('/paiement-detail', arguments: p.id),
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
      child: GestureDetector(onTap: onTap, child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: selected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.primaryColor)),
      )),
    );
  }
}