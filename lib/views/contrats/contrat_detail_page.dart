import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/contrat_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class ContratDetailPage extends StatelessWidget {
  const ContratDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ContratController>();
    ctrl.fetchContratDetails(Get.arguments ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Contrat'),
        actions: [
          IconButton(onPressed: () {
            final c = ctrl.selectedContrat.value;
            if (c != null) { ctrl.fillForm(c); Get.toNamed('/contrat-edit', arguments: c.id); }
          }, icon: const Icon(Icons.edit)),
        ],
      ),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) return const LoadingWidget();
        final c = ctrl.selectedContrat.value;
        if (c == null) return const Center(child: Text('Contrat non trouvé'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15)]),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(c.numeroContrat ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  StatusBadge(label: c.statut.toUpperCase() ?? '', color: AppTheme.getStatutContratColor(c.statut)),
                ]),
                const SizedBox(height: 16),
                Text('${c.montantLoyer.toStringAsFixed(0) ?? '0'} USD / mois', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                if (c.caution != null) Text('Caution: ${c.caution?.toStringAsFixed(0)} USD', style: const TextStyle(color: AppTheme.textSecondary)),
              ]),
            ),
            const SizedBox(height: 20),

            // Infos
            _section(context, 'Informations', [
              _row(Icons.person, 'Locataire', c.locataireNom ?? '-'),
              _row(Icons.apartment, 'Bien', '${c.codeBien ?? ''} - ${c.titreBien ?? ''}'),
              _row(Icons.calendar_today, 'Début', c.dateDebut ?? '-'),
              _row(Icons.event, 'Fin', c.dateFin ?? '-'),
              _row(Icons.repeat, 'Périodicité', c.periodicite ?? 'mensuel'),
            ]),
            const SizedBox(height: 20),

            // Actions
            if (c.statut == 'actif')
              SizedBox(
                width: double.infinity, height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => ctrl.confirmResiliation(c.id ?? 0, c.numeroContrat ?? ''),
                  icon: const Icon(Icons.cancel, color: AppTheme.errorColor),
                  label: const Text('Résilier le contrat', style: TextStyle(color: AppTheme.errorColor)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorColor)),
                ),
              ),
            const SizedBox(height: 40),
          ]),
        );
      }),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTheme.headline3),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
    );
  }
}