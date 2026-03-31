import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/maintenance_controller.dart';
import '../../app/controllers/bien_controller.dart';
import '../../app/themes/app_theme.dart';

class MaintenanceFormPage extends StatelessWidget {
  final bool isEditing;
  const MaintenanceFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MaintenanceController>();
    final bienCtrl = Get.put(BienController());
    if (bienCtrl.biensList.isEmpty) bienCtrl.fetchBiens();

    final typesPanne = ['Fuite d\'eau', 'Électricité', 'Climatisation', 'Serrure', 'Peinture', 'Autre'];

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier Ticket' : 'Nouveau Ticket')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: ctrl.formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Bien concerné', style: AppTheme.headline3),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<int>(
              value: ctrl.formBienId.value,
              decoration: const InputDecoration(labelText: 'Sélectionner un bien *', prefixIcon: Icon(Icons.apartment)),
              items: bienCtrl.biensList.map((b) => DropdownMenuItem(value: b.id, child: Text('${b.codeBien ?? ''} - ${b.titre ?? ''}'))).toList(),
              onChanged: (v) => ctrl.formBienId.value = v,
              validator: (v) => v == null ? 'Sélectionnez un bien' : null,
            )),
        const SizedBox(height: 24),

        const Text('Type de panne', style: AppTheme.headline3),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: typesPanne.map((t) => GestureDetector(
              onTap: () => ctrl.typePanneController.text = t,
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: ctrl.typePanneController.text == t ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      Icon(AppTheme.getTypePanneIcon(t), color: ctrl.typePanneController.text == t ? Colors.white : AppTheme.primaryColor),
                      const SizedBox(height: 4),
                      Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ctrl.typePanneController.text == t ? Colors.white : AppTheme.primaryColor)),
                    ]),
                  )),
            )).toList()),
        const SizedBox(height: 24),

        const Text('Détails', style: AppTheme.headline3),
        const SizedBox(height: 12),
        TextFormField(controller: ctrl.titreController, decoration: const InputDecoration(labelText: 'Titre *', hintText: 'Ex: Fuite robinet cuisine'), validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.descriptionController, decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true, hintText: 'Décrivez le problème...'), maxLines: 4),
        const SizedBox(height: 24),

        const Text('Urgence', style: AppTheme.headline3),
        const SizedBox(height: 12),
        Obx(() => Row(children: ctrl.priorites.map((p) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: GestureDetector(
              onTap: () => ctrl.formPriorite.value = p,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ctrl.formPriorite.value == p ? AppTheme.getPrioriteColor(p) : AppTheme.getPrioriteColor(p).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(AppTheme.getPrioriteLabel(p), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: ctrl.formPriorite.value == p ? Colors.white : AppTheme.getPrioriteColor(p)))),
              ),
            )))).toList())),
        const SizedBox(height: 40),

        Obx(() => SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
              onPressed: ctrl.isSaving.value ? null : ctrl.createMaintenance,
              icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send),
              label: const Text('Soumettre le Ticket', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            ))),
        const SizedBox(height: 20),
      ]))),
    );
  }
}