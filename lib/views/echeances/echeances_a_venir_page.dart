import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/echeance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class EcheancesAVenirPage extends StatelessWidget {
  const EcheancesAVenirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(EcheanceController());
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.fetchEcheancesAVenir(jours: 30));

    return Scaffold(
      appBar: AppBar(title: const Text('Échéances à Venir')),
      body: Obx(() {
        if (ctrl.isAVenirLoading.value) return const LoadingWidget();
        if (ctrl.echeancesAVenir.isEmpty) return const EmptyState(icon: Icons.event_available, title: 'Aucune échéance à venir', subtitle: 'Pas d\'échéance dans les 30 prochains jours');

        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.echeancesAVenir.length, itemBuilder: (_, i) {
          final e = ctrl.echeancesAVenir[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: const Border(left: BorderSide(color: AppTheme.infoColor, width: 4))),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.infoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.schedule, color: AppTheme.infoColor)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.dateEcheance ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text('${e.montantAttendu.toStringAsFixed(0) ?? '0'} USD', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              ])),
            ]),
          );
        });
      }),
    );
  }
}