import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/visite_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class VisitesListPage extends StatelessWidget {
  const VisitesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(VisiteController());
    return Scaffold(
      appBar: AppBar(title: const Text('Visites'), actions: [IconButton(onPressed: () => Get.toNamed('/visite-reserver'), icon: const Icon(Icons.add))]),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.visitesList.isEmpty) return const LoadingWidget();
        if (ctrl.visitesList.isEmpty) return EmptyState(icon: Icons.tour, title: 'Aucune visite', buttonText: 'Programmer', onButtonPressed: () => Get.toNamed('/visite-reserver'));
        return RefreshIndicator(onRefresh: () => ctrl.fetchVisites(refresh: true), child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.visitesList.length, itemBuilder: (_, i) {
          final v = ctrl.visitesList[i];
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(v.clientNom ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                StatusBadge(label: v.statut ?? '', color: ctrl.getStatutColor(v.statut)),
              ]),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary), const SizedBox(width: 6), Text(v.dateVisite ?? '', style: const TextStyle(color: AppTheme.textSecondary))]),
              if (v.clientTelephone != null) ...[const SizedBox(height: 4), Row(children: [const Icon(Icons.phone, size: 16, color: AppTheme.textSecondary), const SizedBox(width: 6), Text(v.clientTelephone!, style: const TextStyle(color: AppTheme.textSecondary))])],
            ]),
          );
        }));
      }),
    );
  }
}