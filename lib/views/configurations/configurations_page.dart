import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/configuration_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ConfigurationController());
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: Obx(() {
        if (ctrl.isLoading.value) return const LoadingWidget();
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: ctrl.configurationsList.length, itemBuilder: (_, i) {
          final c = ctrl.configurationsList[i];
          return Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.settings, color: AppTheme.primaryColor)),
              title: Text(c.description ?? c.cle ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(c.valeur ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
              trailing: c.modifiable == 1 ? IconButton(icon: const Icon(Icons.edit, color: AppTheme.primaryColor), onPressed: () => ctrl.showEditDialog(c)) : null,
            ));
        });
      }),
    );
  }
}