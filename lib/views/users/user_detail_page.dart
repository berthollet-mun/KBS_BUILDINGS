import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/user_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserController>();
    ctrl.fetchUserDetails(Get.arguments ?? 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail Utilisateur'), actions: [
        IconButton(onPressed: () { final u = ctrl.selectedUser.value; if (u != null) { ctrl.fillForm(u); Get.toNamed('/user-edit', arguments: u.id); } }, icon: const Icon(Icons.edit)),
      ]),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) return const LoadingWidget();
        final u = ctrl.selectedUser.value;
        if (u == null) return const Center(child: Text('Utilisateur non trouvé'));

        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15)]),
            child: Column(children: [
              CircleAvatar(radius: 45, backgroundColor: AppTheme.primaryColor.withOpacity(0.1), child: Text('${u.prenom?.substring(0, 1) ?? ''}${u.nom.substring(0, 1)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
              const SizedBox(height: 16),
              Text('${u.prenom ?? ''} ${u.nom}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                StatusBadge(label: u.roleNom ?? '', color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                StatusBadge(label: u.statut, color: u.isActif ? AppTheme.successColor : AppTheme.errorColor),
              ]),
            ])),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Informations', style: AppTheme.headline3),
              const SizedBox(height: 16),
              _row(Icons.email, 'Email', u.email),
              _row(Icons.phone, 'Téléphone', u.telephone ?? 'Non renseigné'),
              _row(Icons.calendar_today, 'Créé le', u.createdAt ?? '-'),
              _row(Icons.access_time, 'Dernière connexion', u.derniereConnexion ?? 'Jamais'),
            ])),
          const SizedBox(height: 24),
          if (u.isActif)
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => ctrl.confirmDelete(u.id, '${u.prenom ?? ''} ${u.nom}'), icon: const Icon(Icons.block, color: AppTheme.errorColor), label: const Text('Désactiver', style: TextStyle(color: AppTheme.errorColor)), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorColor)))),
          const SizedBox(height: 40),
        ]));
      }),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Icon(icon, size: 20, color: AppTheme.primaryColor), const SizedBox(width: 12), SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))), Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)))]));
  }
}