// lib/views/maintenances/maintenance_form_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import 'package:kbs/controllers/maintenance_controller.dart';
import '../../app/themes/app_theme.dart';

class MaintenanceFormPage extends StatelessWidget {
  final bool isEditing;
  const MaintenanceFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MaintenanceController>();
    final bienCtrl = Get.put(BienController());
    if (bienCtrl.biensList.isEmpty) bienCtrl.fetchBiens();

    final typesPanne = [
      {'label': "Fuite d'eau", 'icon': Icons.water_drop},
      {'label': 'Électricité', 'icon': Icons.electrical_services},
      {'label': 'Climatisation', 'icon': Icons.ac_unit},
      {'label': 'Serrure', 'icon': Icons.lock},
      {'label': 'Peinture', 'icon': Icons.format_paint},
      {'label': 'Autre', 'icon': Icons.build},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier Ticket' : 'Nouveau Ticket'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== BIEN CONCERNÉ =====
              const Text('Bien concerné', style: AppTheme.headline3),
              const SizedBox(height: 12),
              Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<int>(
                      value: ctrl.formBienId.value,
                      decoration: const InputDecoration(
                        labelText: 'Sélectionner un bien *',
                        prefixIcon: Icon(Icons.apartment_rounded),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: bienCtrl.biensList
                          .map((b) => DropdownMenuItem(
                                value: b.id,
                                child: Text(
                                  '${b.codeBien ?? ''} - ${b.titre ?? ''}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (v) => ctrl.formBienId.value = v,
                      validator: (v) =>
                          v == null ? 'Sélectionnez un bien' : null,
                    ),
                  )),

              const SizedBox(height: 24),

              // ===== TYPE DE PANNE =====
              const Text('Type de panne', style: AppTheme.headline3),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: typesPanne.length,
                itemBuilder: (context, index) {
                  final type = typesPanne[index];
                  final label = type['label'] as String;
                  final icon = type['icon'] as IconData;

                  return GestureDetector(
                    onTap: () => ctrl.typePanneController.text = label,
                    child: Obx(() {
                      final isSelected =
                          ctrl.typePanneController.text == label;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: AppTheme.primaryColor
                                      .withOpacity(0.12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ===== DÉTAILS =====
              const Text('Détails', style: AppTheme.headline3),
              const SizedBox(height: 12),
              TextFormField(
                controller: ctrl.titreController,
                decoration: InputDecoration(
                  labelText: 'Titre *',
                  hintText: 'Ex: Fuite robinet cuisine',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ctrl.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  hintText: 'Décrivez le problème en détail...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 4,
              ),

              const SizedBox(height: 24),

              // ===== PHOTOS =====
              const Text('Photos', style: AppTheme.headline3),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPhotoPlaceholder(),
                  const SizedBox(width: 12),
                  _buildPhotoPlaceholder(),
                  const SizedBox(width: 12),
                  _buildAddPhotoButton(),
                ],
              ),

              const SizedBox(height: 24),

              // ===== URGENCE =====
              const Text('Urgence', style: AppTheme.headline3),
              const SizedBox(height: 12),
              Obx(() => Row(
                    children: ctrl.priorites
                        .map((p) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () => ctrl.formPriorite.value = p,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    decoration: BoxDecoration(
                                      color: ctrl.formPriorite.value == p
                                          ? AppTheme.getPrioriteColor(p)
                                          : AppTheme.getPrioriteColor(p)
                                              .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border:
                                          ctrl.formPriorite.value == p
                                              ? null
                                              : Border.all(
                                                  color: AppTheme
                                                          .getPrioriteColor(
                                                              p)
                                                      .withOpacity(0.3)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppTheme.getPrioriteLabel(p),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color:
                                              ctrl.formPriorite.value == p
                                                  ? Colors.white
                                                  : AppTheme
                                                      .getPrioriteColor(p),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )),

              const SizedBox(height: 40),

              // ===== BOUTON SOUMETTRE =====
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: ctrl.isSaving.value
                          ? null
                          : ctrl.createMaintenance,
                      icon: ctrl.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                      label: const Text(
                        'Soumettre le Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.15),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 30,
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Implémenter la sélection de photo
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add_a_photo_rounded,
            size: 28,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}