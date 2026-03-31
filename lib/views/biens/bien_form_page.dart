import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import 'package:kbs/controllers/proprietaire_controller.dart';
import '../../app/themes/app_theme.dart';

class BienFormPage extends StatelessWidget {
  final bool isEditing;
  const BienFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BienController>();
    final propCtrl = Get.put(ProprietaireController());

    // Charger les propriétaires pour le dropdown
    if (propCtrl.proprietairesList.isEmpty) {
      propCtrl.fetchProprietaires();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le Bien' : 'Nouveau Bien'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== INFOS DE BASE =====
              const Text('Informations générales',
                  style: AppTheme.headline3),
              const SizedBox(height: 16),

              // Titre
              TextFormField(
                controller: controller.titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre du bien *',
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Ex: Villa moderne 4 chambres',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 16),

              // Type de bien
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedFormTypeBien.value,
                    decoration: const InputDecoration(
                      labelText: 'Type de bien *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: controller.typesBien
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Row(
                                children: [
                                  Icon(
                                      AppTheme.getTypeBienIcon(t),
                                      size: 20,
                                      color:
                                          AppTheme.primaryColor),
                                  const SizedBox(width: 8),
                                  Text(AppTheme.getTypeBienLabel(
                                      t)),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => controller
                        .selectedFormTypeBien.value = v ?? 'maison',
                  )),
              const SizedBox(height: 16),

              // Propriétaire
              Obx(() => DropdownButtonFormField<int>(
                    value: controller.formProprietaireId.value,
                    decoration: const InputDecoration(
                      labelText: 'Propriétaire *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: propCtrl.proprietairesList
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(
                                  p.nomComplet ?? 'Sans nom'),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        controller.formProprietaireId.value = v,
                    validator: (v) =>
                        v == null ? 'Sélectionnez un propriétaire' : null,
                  )),

              const SizedBox(height: 24),

              // ===== LOCALISATION =====
              const Text('Localisation', style: AppTheme.headline3),
              const SizedBox(height: 16),

              TextFormField(
                controller: controller.adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.communeController,
                      decoration: const InputDecoration(
                          labelText: 'Commune'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.villeController,
                      decoration: const InputDecoration(
                          labelText: 'Ville'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: controller.quartierController,
                decoration: const InputDecoration(
                  labelText: 'Quartier',
                  prefixIcon: Icon(Icons.map),
                ),
              ),

              const SizedBox(height: 24),

              // ===== CARACTÉRISTIQUES =====
              const Text('Caractéristiques',
                  style: AppTheme.headline3),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.surfaceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Surface (m²)',
                        prefixIcon: Icon(Icons.square_foot),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.nbPiecesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nb pièces',
                        prefixIcon: Icon(Icons.meeting_room),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.etageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Étage',
                        prefixIcon: Icon(Icons.stairs),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => SwitchListTile(
                          title: const Text('Meublé'),
                          value: controller.isMeuble.value,
                          onChanged: (v) =>
                              controller.isMeuble.value = v,
                          contentPadding: EdgeInsets.zero,
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== TARIFICATION =====
              const Text('Tarification', style: AppTheme.headline3),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.prixLoyerController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prix loyer (USD)',
                        prefixIcon: Icon(Icons.payments),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.prixVenteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prix vente (USD)',
                        prefixIcon: Icon(Icons.sell),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== DESCRIPTION =====
              const Text('Description', style: AppTheme.headline3),
              const SizedBox(height: 16),

              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description du bien',
                  alignLabelWithHint: true,
                  hintText:
                      'Décrivez le bien en détail...',
                ),
              ),

              const SizedBox(height: 24),

              // ===== GPS =====
              const Text('Coordonnées GPS (optionnel)',
                  style: AppTheme.headline3),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.latitudeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        prefixIcon: Icon(Icons.gps_fixed),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.longitudeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        prefixIcon: Icon(Icons.gps_fixed),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ===== BOUTON SUBMIT =====
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => isEditing
                              ? controller
                                  .updateBien(Get.arguments ?? 0)
                              : controller.createBien(),
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(isEditing
                              ? Icons.save
                              : Icons.add_home),
                      label: Text(
                        isEditing
                            ? 'Enregistrer les modifications'
                            : 'Créer le Bien',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}