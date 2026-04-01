import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/role_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RoleController());
    return Scaffold(
      appBar: AppBar(title: const Text('Rôles'), actions: [
        IconButton(onPressed: () => _showCreateDialog(context, ctrl), icon: const Icon(Icons.add)),
      ]),
      body: Obx(() {
        if (ctrl.isLoading.value) return const LoadingWidget();
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.rolesList.length, itemBuilder: (_, i) {
          final r = ctrl.rolesList[i];
          return Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.security, color: AppTheme.primaryColor)),
              title: Text(r.nom.capitalizeFirst ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: Text(r.description ?? '', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            ));
        });
      }),
    );
  }

  void _showCreateDialog(BuildContext context, RoleController ctrl) {
    Get.defaultDialog(
      title: 'Nouveau Rôle',
      content: Padding(padding: const EdgeInsets.all(8), child: Form(key: ctrl.formKey, child: Column(children: [
        TextFormField(controller: ctrl.nomController, decoration: const InputDecoration(labelText: 'Nom du rôle *'), validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 12),
        TextFormField(controller: ctrl.descriptionController, decoration: const InputDecoration(labelText: 'Description')),
      ]))),
      textCancel: 'Annuler',
      textConfirm: 'Créer',
      confirmTextColor: Colors.white,
      onConfirm: ctrl.createRole,
    );
  }
}