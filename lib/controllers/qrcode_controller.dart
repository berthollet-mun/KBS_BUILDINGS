// lib/app/controllers/qrcode_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/core/services/qrcode_service.dart';
import '../../data/models/qrcode_model.dart';

class QrCodeController extends GetxController {
  final QrCodeService _service = Get.find<QrCodeService>();

  // --- État ---
  final isLoading = false.obs;
  final isGenerating = false.obs;
  final errorMessage = ''.obs;
  final Rx<QrCodeModel?> currentQrCode = Rx<QrCodeModel?>(null);
  final Rx<Map<String, dynamic>?> scannedBienData =
      Rx<Map<String, dynamic>?>(null);

  // ========== GÉNÉRER ==========

  Future<void> generateQrCode(int bienId) async {
    isGenerating.value = true;
    errorMessage.value = '';

    try {
      final result = await _service.generateQrCode(bienId);
      if (result.success) {
        currentQrCode.value = _service.parseQrCode(result);
        Get.snackbar('Succès', 'QR Code généré avec succès',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        errorMessage.value = result.message;
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = 'Impossible de générer le QR Code';
      Get.snackbar('Erreur', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isGenerating.value = false;
    }
  }

  // ========== SCANNER ==========

  Future<void> scanQrCode(String code) async {
    isLoading.value = true;
    errorMessage.value = '';
    scannedBienData.value = null;

    try {
      final result = await _service.scanQrCode(code);
      if (result.success) {
        scannedBienData.value =
            result.responseData as Map<String, dynamic>?;
      } else {
        errorMessage.value = result.message;
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = 'Impossible de scanner le QR Code';
      Get.snackbar('Erreur', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== VOIR QR PAR BIEN ==========

  Future<void> getQrCodeByBien(int bienId) async {
    isLoading.value = true;
    errorMessage.value = '';
    currentQrCode.value = null;

    try {
      final result = await _service.getQrCodeByBien(bienId);
      if (result.success) {
        currentQrCode.value = _service.parseQrCode(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value = 'Impossible de charger le QR Code';
    } finally {
      isLoading.value = false;
    }
  }

  // --- Getters ---
  bool get hasQrCode => currentQrCode.value != null;
  bool get hasScannedData => scannedBienData.value != null;
}