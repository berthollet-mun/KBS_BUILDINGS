// lib/app/controllers/configuration_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/configuration_service.dart';
import '../../data/models/configuration_model.dart';

class ConfigurationController extends GetxController {
  final ConfigurationService _service =
      Get.find<ConfigurationService>();

  // --- État ---
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final RxList<ConfigurationModel> configurationsList =
      <ConfigurationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConfigurations();
  }

  // ========== LISTE ==========

  Future<void> fetchConfigurations() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getConfigurations();
      if (result.success) {
        configurationsList.value =
            _service.parseConfigurations(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des configurations.";
    } finally {
      isLoading.value = false;
    }
  }

  // ========== MODIFICATION ==========

  Future<void> updateConfiguration(String cle, String valeur) async {
    isSaving.value = true;

    try {
      final result = await _service.updateConfiguration(cle, valeur);
      if (result.success) {
        fetchConfigurations();
        Get.snackbar('Succès', 'Configuration mise à jour',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Impossible de modifier la configuration',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Dialogue d'édition d'une configuration
  void showEditDialog(ConfigurationModel config) {
    final controller = TextEditingController(text: config.valeur);

    Get.defaultDialog(
      title: 'Modifier : ${config.description ?? config.cle}',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: config.cle,
            hintText: 'Nouvelle valeur',
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      textCancel: 'Annuler',
      textConfirm: 'Enregistrer',
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        Get.back();
        updateConfiguration(config.cle, controller.text.trim());
              controller.dispose();
      },
      onCancel: () {
        controller.dispose();
      },
    );
  }

  // --- Getters ---
  String? getConfigValue(String cle) {
    try {
      return configurationsList
          .firstWhere((c) => c.cle == cle)
          .valeur;
    } catch (_) {
      return null;
    }
  }

  String get nomEntreprise =>
      getConfigValue('nom_entreprise') ?? 'IMMO API';
  String get devise => getConfigValue('devise') ?? 'USD';
}