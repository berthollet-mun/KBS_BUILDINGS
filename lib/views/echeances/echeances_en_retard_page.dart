import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/echeance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class EcheancesEnRetardPage extends StatelessWidget {
  const EcheancesEnRetardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(EcheanceController());
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.fetchEcheancesEnRetard());

    return Scaffold(
      appBar: AppBar(title: const Text('Échéances en Retard'), backgroundColor: AppTheme.errorColor),
      body: Obx(() {
        if (ctrl.isRetardsLoading.value) return const LoadingWidget(message: 'Vérification des retards...');
        if (ctrl.echeancesEnRetard.isEmpty) return const EmptyState(icon: Icons.check_circle_outline, title: 'Aucun retard !', subtitle: 'Tous les loyers sont à jour');

        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.echeancesEnRetard.length, itemBuilder: (_, i) {
          final e = ctrl.echeancesEnRetard[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16),
              border: const Border(left: BorderSide(color: AppTheme.errorColor, width: 4)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(e.dateEcheance ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.errorColor, borderRadius: BorderRadius.circular(12)), child: Text('${e.joursRetard ?? 0} jours', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 8),
              Text('Montant: ${e.montantAttendu.toStringAsFixed(0) ?? '0'} USD', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.errorColor)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: ElevatedButton.icon(onPressed: () => Get.toNamed('/paiement-create'), icon: const Icon(Icons.payment, size: 18), label: const Text('Payer'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor))),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('Rappel')),
              ]),
            ]),
          );
        });
      }),
    );
  }
}