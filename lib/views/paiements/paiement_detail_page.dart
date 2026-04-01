import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/paiement_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';

class PaiementDetailPage extends StatelessWidget {
  const PaiementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PaiementController>();
    ctrl.fetchPaiementDetails(Get.arguments ?? 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail Paiement')),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) return const LoadingWidget();
        final p = ctrl.selectedPaiement.value;
        if (p == null) return const Center(child: Text('Paiement non trouvé'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Montant principal
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppTheme.successColor, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text('${p.montant.toStringAsFixed(0) ?? '0'} USD', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Réf: ${p.referencePaiement ?? ''}', style: TextStyle(color: Colors.white.withOpacity(0.8))),
              ]),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Détails du paiement', style: AppTheme.headline3),
                const SizedBox(height: 16),
                _row(Icons.calendar_today, 'Date', p.datePaiement ?? '-'),
                _row(Icons.payment, 'Mode', AppTheme.getModePaiementLabel(p.modePaiement)),
                _row(Icons.description, 'Contrat', p.numeroContrat ?? '-'),
                _row(Icons.person, 'Locataire', p.locataireNom ?? '-'),
                _row(Icons.apartment, 'Bien', p.codeBien ?? '-'),
                _row(Icons.date_range, 'Période', p.periodeConcernee ?? '-'),
                _row(Icons.info, 'Statut', p.statut ?? '-'),
              ]),
            ),
            const SizedBox(height: 40),
          ]),
        );
      }),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
    );
  }
}