import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/locataire_controller.dart';
import '../../app/themes/app_theme.dart';

class LocataireFormPage extends StatelessWidget {
  final bool isEditing;
  const LocataireFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LocataireController>();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier Locataire' : 'Nouveau Locataire')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.person_add, size: 50, color: AppTheme.accentColor),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Informations personnelles', style: AppTheme.headline3),
              const SizedBox(height: 16),
              TextFormField(controller: ctrl.nomCompletController, decoration: const InputDecoration(labelText: 'Nom complet *', prefixIcon: Icon(Icons.person), hintText: 'Ex: Famille Mukendi David'), validator: (v) => v!.isEmpty ? 'Le nom est requis' : null),
              const SizedBox(height: 16),
              TextFormField(controller: ctrl.telephoneController, decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone), hintText: '+243...'), keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              TextFormField(controller: ctrl.emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), hintText: 'email@exemple.com'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              const Text('Adresse & Identification', style: AppTheme.headline3),
              const SizedBox(height: 16),
              TextFormField(controller: ctrl.adresseController, decoration: const InputDecoration(labelText: 'Adresse complète', prefixIcon: Icon(Icons.location_on)), maxLines: 2),
              const SizedBox(height: 16),
              TextFormField(controller: ctrl.pieceIdentiteController, decoration: const InputDecoration(labelText: 'Pièce d\'identité', prefixIcon: Icon(Icons.badge))),
              const SizedBox(height: 40),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: ctrl.isSaving.value ? null : () => isEditing ? ctrl.updateLocataire(Get.arguments ?? 0) : ctrl.createLocataire(),
                      icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(isEditing ? Icons.save : Icons.person_add),
                      label: Text(isEditing ? 'Enregistrer' : 'Créer le Locataire', style: const TextStyle(fontSize: 16)),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}