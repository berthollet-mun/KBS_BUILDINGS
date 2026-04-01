import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/contrat_controller.dart';
import 'package:kbs/controllers/paiement_controller.dart';
import '../../app/themes/app_theme.dart';

class PaiementFormPage extends StatelessWidget {
  const PaiementFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PaiementController>();
    final contratCtrl = Get.put(ContratController());
    if (contratCtrl.contratsList.isEmpty) contratCtrl.fetchContrats();

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Paiement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.successColor.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.payments, size: 50, color: AppTheme.successColor))),
            const SizedBox(height: 24),

            const Text('Contrat concerné', style: AppTheme.headline3),
            const SizedBox(height: 12),
            Obx(() => DropdownButtonFormField<int>(
                  initialValue: ctrl.formContratId.value,
                  decoration: const InputDecoration(labelText: 'Sélectionner un contrat *', prefixIcon: Icon(Icons.description)),
                  items: contratCtrl.contratsList.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.numeroContrat ?? ''} - ${c.locataireNom ?? ''}'))).toList(),
                  onChanged: (v) => ctrl.formContratId.value = v,
                  validator: (v) => v == null ? 'Sélectionnez un contrat' : null,
                )),
            const SizedBox(height: 24),

            const Text('Informations du paiement', style: AppTheme.headline3),
            const SizedBox(height: 12),
            TextFormField(controller: ctrl.montantController, decoration: const InputDecoration(labelText: 'Montant (USD) *', prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Le montant est requis' : null),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  initialValue: ctrl.formModePaiement.value,
                  decoration: const InputDecoration(labelText: 'Mode de paiement', prefixIcon: Icon(Icons.payment)),
                  items: ctrl.modesPaiement.map((m) => DropdownMenuItem(value: m, child: Row(children: [Icon(AppTheme.getModePaiementIcon(m), size: 20, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(AppTheme.getModePaiementLabel(m))]))).toList(),
                  onChanged: (v) => ctrl.formModePaiement.value = v ?? 'cash',
                )),
            const SizedBox(height: 16),
            TextFormField(controller: ctrl.datePaiementController, decoration: const InputDecoration(labelText: 'Date du paiement', prefixIcon: Icon(Icons.calendar_today)), onTap: () => ctrl.selectDate(context, ctrl.datePaiementController), readOnly: true),
            const SizedBox(height: 16),
            TextFormField(controller: ctrl.periodeConcerneeController, decoration: const InputDecoration(labelText: 'Période concernée', prefixIcon: Icon(Icons.date_range), hintText: 'Ex: 06/2025')),
            const SizedBox(height: 16),
            TextFormField(controller: ctrl.commentaireController, decoration: const InputDecoration(labelText: 'Commentaire', alignLabelWithHint: true), maxLines: 3),
            const SizedBox(height: 40),

            Obx(() => SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton.icon(
                    onPressed: ctrl.isSaving.value ? null : ctrl.createPaiement,
                    icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.check),
                    label: const Text('Enregistrer le Paiement', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor),
                  ),
                )),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}