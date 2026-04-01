import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import 'package:kbs/controllers/contrat_controller.dart';
import 'package:kbs/controllers/locataire_controller.dart';
import '../../app/themes/app_theme.dart';

class ContratFormPage extends StatelessWidget {
  final bool isEditing;
  const ContratFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ContratController>();
    final bienCtrl = Get.put(BienController());
    final locCtrl = Get.put(LocataireController());

    if (bienCtrl.biensList.isEmpty) bienCtrl.fetchBiens();
    if (locCtrl.locatairesList.isEmpty) locCtrl.fetchLocataires();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier Contrat' : 'Nouveau Contrat')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.description, size: 50, color: AppTheme.primaryColor))),
            const SizedBox(height: 24),

            if (!isEditing) ...[
              const Text('Bien concerné', style: AppTheme.headline3),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<int>(
                    initialValue: ctrl.formBienId.value,
                    decoration: const InputDecoration(labelText: 'Sélectionner un bien *', prefixIcon: Icon(Icons.apartment)),
                    items: bienCtrl.biensList.map((b) => DropdownMenuItem(value: b.id, child: Text('${b.codeBien ?? ''} - ${b.titre ?? ''}'))).toList(),
                    onChanged: (v) => ctrl.formBienId.value = v,
                    validator: (v) => v == null ? 'Sélectionnez un bien' : null,
                  )),
              const SizedBox(height: 16),

              const Text('Locataire', style: AppTheme.headline3),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<int>(
                    initialValue: ctrl.formLocataireId.value,
                    decoration: const InputDecoration(labelText: 'Sélectionner un locataire *', prefixIcon: Icon(Icons.person)),
                    items: locCtrl.locatairesList.map((l) => DropdownMenuItem(value: l.id, child: Text(l.nomComplet ?? ''))).toList(),
                    onChanged: (v) => ctrl.formLocataireId.value = v,
                    validator: (v) => v == null ? 'Sélectionnez un locataire' : null,
                  )),
              const SizedBox(height: 24),
            ],

            const Text('Période du contrat', style: AppTheme.headline3),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: ctrl.dateDebutController, decoration: const InputDecoration(labelText: 'Date début *', prefixIcon: Icon(Icons.calendar_today)), onTap: () => ctrl.selectDate(context, ctrl.dateDebutController), readOnly: true, validator: (v) => v!.isEmpty ? 'Requis' : null)),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: ctrl.dateFinController, decoration: const InputDecoration(labelText: 'Date fin *', prefixIcon: Icon(Icons.event)), onTap: () => ctrl.selectDate(context, ctrl.dateFinController), readOnly: true, validator: (v) => v!.isEmpty ? 'Requis' : null)),
            ]),
            const SizedBox(height: 24),

            const Text('Conditions financières', style: AppTheme.headline3),
            const SizedBox(height: 12),
            TextFormField(controller: ctrl.montantLoyerController, decoration: const InputDecoration(labelText: 'Montant loyer mensuel (USD) *', prefixIcon: Icon(Icons.payments)), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Requis' : null),
            const SizedBox(height: 16),
            TextFormField(controller: ctrl.cautionController, decoration: const InputDecoration(labelText: 'Caution (USD)', prefixIcon: Icon(Icons.account_balance_wallet)), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: ctrl.formPeriodicite.value,
                  decoration: const InputDecoration(labelText: 'Périodicité', prefixIcon: Icon(Icons.repeat)),
                  items: ctrl.periodicites.map((p) => DropdownMenuItem(value: p, child: Text(p.capitalizeFirst!))).toList(),
                  onChanged: (v) => ctrl.formPeriodicite.value = v ?? 'mensuel',
                )),
            const SizedBox(height: 40),

            Obx(() => SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton.icon(
                    onPressed: ctrl.isSaving.value ? null : () => isEditing ? ctrl.updateContrat(Get.arguments ?? 0) : ctrl.createContrat(),
                    icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(isEditing ? Icons.save : Icons.description),
                    label: Text(isEditing ? 'Enregistrer' : 'Créer le Contrat', style: const TextStyle(fontSize: 16)),
                  ),
                )),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}