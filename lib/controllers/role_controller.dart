// lib/app/controllers/role_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/role_service.dart';
import '../../data/models/role_model.dart';

class RoleController extends GetxController {
  final RoleService _service = Get.find<RoleService>();

  // --- État ---
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final RxList<RoleModel> rolesList = <RoleModel>[].obs;

  // --- Formulaire ---
  final formKey = GlobalKey<FormState>();
  late TextEditingController nomController;
  late TextEditingController descriptionController;

  @override
  void onInit() {
    super.onInit();
    nomController = TextEditingController();
    descriptionController = TextEditingController();
    fetchRoles();
  }

  @override
  void onClose() {
    nomController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // ========== LISTE ==========

  Future<void> fetchRoles() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.getRoles();
      if (result.success) {
        rolesList.value = _service.parseRoles(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des rôles.";
    } finally {
      isLoading.value = false;
    }
  }

  // ========== CRÉATION ==========

  Future<void> createRole() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final result = await _service.createRole(
        nom: nomController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      );

      if (result.success) {
        nomController.clear();
        descriptionController.clear();
        Get.back();
        fetchRoles();
        Get.snackbar('Succès', 'Rôle créé avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le rôle',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // --- Getters ---
  RoleModel? getRoleById(int id) {
    try {
      return rolesList.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  String getRoleNom(int id) {
    return getRoleById(id)?.nom ?? 'Inconnu';
  }
}