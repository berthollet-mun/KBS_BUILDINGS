import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/document_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DocumentController());
    ctrl.fetchDocuments();
    return Scaffold(
      appBar: AppBar(title: const Text('Documents'), actions: [IconButton(onPressed: () => Get.toNamed('/document-upload'), icon: const Icon(Icons.upload_file))]),
      body: Obx(() {
        if (ctrl.isLoading.value) return const LoadingWidget();
        if (ctrl.documentsList.isEmpty) return EmptyState(icon: Icons.folder_open, title: 'Aucun document', buttonText: 'Uploader', onButtonPressed: () => Get.toNamed('/document-upload'));
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.documentsList.length, itemBuilder: (_, i) {
          final d = ctrl.documentsList[i];
          return Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
            child: ListTile(leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.insert_drive_file, color: AppTheme.primaryColor)), title: Text(d.nomFichier ?? 'Document'), subtitle: Text(d.typeDocument ?? ''), trailing: const Icon(Icons.download)));
        });
      }),
    );
  }
}