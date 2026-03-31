import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/visite_controller.dart';
import '../../app/controllers/bien_controller.dart';
import '../../app/themes/app_theme.dart';

class VisiteFormPage extends StatelessWidget {
  const VisiteFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<VisiteController>();
    final bienCtrl = Get.put(BienController());
    if (bienCtrl.biensList.isEmpty) bienCtrl.fetchBiens();

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver une Visite')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: ctrl.formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.infoColor.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.calendar_today, size: 50, color: AppTheme.infoColor))),
        const SizedBox(height: 24),
        const Text('Bien à visiter', style: AppTheme.headline3),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<int>(value: ctrl.formBienId.value, decoration: const InputDecoration(labelText: 'Sélectionner un bien *', prefixIcon: Icon(Icons.apartment)), items: bienCtrl.biensList.map((b) => DropdownMenuItem(value: b.id, child: Text(b.titre ?? ''))).toList(), onChanged: (v) => ctrl.formBienId.value = v, validator: (v) => v == null ? 'Requis' : null)),
        const SizedBox(height: 24),
        const Text('Vos informations', style: AppTheme.headline3),
        const SizedBox(height: 12),
        TextFormField(controller: ctrl.clientNomController, decoration: const InputDecoration(labelText: 'Votre nom complet *', prefixIcon: Icon(Icons.person)), validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.clientTelephoneController, decoration: const InputDecoration(labelText: 'Téléphone *', prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.clientEmailController, decoration: const InputDecoration(labelText: 'Email (optionnel)', prefixIcon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 24),
        const Text('Date et heure', style: AppTheme.headline3),
        const SizedBox(height: 12),
        TextFormField(controller: ctrl.dateVisiteController, decoration: const InputDecoration(labelText: 'Date et heure de visite *', prefixIcon: Icon(Icons.access_time)), onTap: () => ctrl.selectDateTime(context), readOnly: true, validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.observationController, decoration: const InputDecoration(labelText: 'Observation (optionnel)', alignLabelWithHint: true), maxLines: 3),
        const SizedBox(height: 40),
        Obx(() => SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: ctrl.isSaving.value ? null : ctrl.reserverVisite, icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.check), label: const Text('Réserver la Visite', style: TextStyle(fontSize: 16))))),
        const SizedBox(height: 20),
      ]))),
    );
  }
}