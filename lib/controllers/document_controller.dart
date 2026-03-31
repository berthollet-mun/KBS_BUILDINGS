// lib/app/controllers/document_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/document_service.dart';
import '../../data/models/document_model.dart';

class DocumentController extends GetxController {
  final DocumentService _service = Get.find<DocumentService>();

  // --- État ---
  final isLoading = false.obs;
  final isUploading = false.obs;
  final errorMessage = ''.obs;
  final RxList<DocumentModel> documentsList = <DocumentModel>[].obs;

  // --- Filtres ---
  final selectedEntiteType = Rx<String?>(null);
  final selectedEntiteId = Rx<int?>(null);

  // --- Formulaire upload ---
  final Rx<File?> selectedFile = Rx<File?>(null);
  final formTypeDocument = 'autre'.obs;
  final formEntiteType = 'bien'.obs;
  final formEntiteId = Rx<int?>(null);
  final formSubfolder = ''.obs;

  final List<String> typesDocument = [
    'contrat_pdf',
    'recu',
    'piece_identite',
    'photo',
    'rapport',
    'autre'
  ];
  final List<String> entiteTypes = [
    'bien',
    'contrat',
    'proprietaire',
    'locataire'
  ];

  // ========== LISTE ==========

  Future<void> fetchDocuments({
    String? entiteType,
    int? entiteId,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    documentsList.clear();

    try {
      final result = await _service.getDocuments(
        entiteType: entiteType ?? selectedEntiteType.value,
        entiteId: entiteId ?? selectedEntiteId.value,
      );
      if (result.success) {
        documentsList.value = _service.parseDocuments(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Erreur lors de la récupération des documents.";
    } finally {
      isLoading.value = false;
    }
  }

  // ========== UPLOAD ==========

  Future<void> uploadDocument() async {
    if (selectedFile.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un fichier',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (formEntiteId.value == null) {
      Get.snackbar('Erreur', 'Veuillez spécifier l\'entité',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isUploading.value = true;

    try {
      final result = await _service.uploadDocument(
        fichier: selectedFile.value!,
        typeDocument: formTypeDocument.value,
        entiteType: formEntiteType.value,
        entiteId: formEntiteId.value!,
        subfolder: formSubfolder.value.isEmpty
            ? null
            : formSubfolder.value,
      );

      if (result.success) {
        selectedFile.value = null;
        Get.back();
        // Recharger les documents de cette entité
        fetchDocuments(
          entiteType: formEntiteType.value,
          entiteId: formEntiteId.value,
        );
        Get.snackbar('Succès', 'Document uploadé avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'uploader le document',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploading.value = false;
    }
  }

  // --- Helpers ---
  void setFile(File file) {
    selectedFile.value = file;
  }

  void clearFile() {
    selectedFile.value = null;
  }
}