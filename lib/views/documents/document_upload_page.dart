import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/document_controller.dart';
import '../../app/themes/app_theme.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DocumentController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Uploader un Document')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        GestureDetector(
          onTap: () {/* TODO: File picker */},
          child: Container(width: double.infinity, height: 200, decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), style: BorderStyle.solid)),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_upload, size: 60, color: AppTheme.primaryColor), SizedBox(height: 12), Text('Appuyez pour sélectionner un fichier', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500))])),
        ),
        const SizedBox(height: 24),
        Obx(() => DropdownButtonFormField<String>(value: ctrl.formTypeDocument.value, decoration: const InputDecoration(labelText: 'Type de document'), items: ctrl.typesDocument.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => ctrl.formTypeDocument.value = v ?? 'autre')),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(value: ctrl.formEntiteType.value, decoration: const InputDecoration(labelText: 'Lié à'), items: ctrl.entiteTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => ctrl.formEntiteType.value = v ?? 'bien')),
        const SizedBox(height: 40),
        Obx(() => SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: ctrl.isUploading.value ? null : ctrl.uploadDocument, icon: ctrl.isUploading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.upload), label: const Text('Uploader', style: TextStyle(fontSize: 16))))),
      ])),
    );
  }
}