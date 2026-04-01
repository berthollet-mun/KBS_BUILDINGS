import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import '../../app/themes/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();
    ctrl.fillProfileForm();

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        CircleAvatar(radius: 50, backgroundColor: AppTheme.primaryColor.withOpacity(0.1), child: Obx(() => Text(ctrl.currentUser.value?.nom.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)))),
        const SizedBox(height: 16),
        Obx(() => Text(ctrl.userFullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        Obx(() => Text(ctrl.userEmail, style: const TextStyle(color: AppTheme.textSecondary))),
        Obx(() => Padding(padding: const EdgeInsets.only(top: 4), child: Text(ctrl.userRole.capitalizeFirst ?? '', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)))),
        const SizedBox(height: 32),
        Form(key: ctrl.profileFormKey, child: Column(children: [
          TextFormField(controller: ctrl.nameController, decoration: const InputDecoration(labelText: 'Nom', prefixIcon: Icon(Icons.person))),
          const SizedBox(height: 16),
          TextFormField(controller: ctrl.postnomController, decoration: const InputDecoration(labelText: 'Postnom', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 16),
          TextFormField(controller: ctrl.prenomController, decoration: const InputDecoration(labelText: 'Prénom', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 16),
          TextFormField(controller: ctrl.phoneController, decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
          const SizedBox(height: 24),
          Obx(() => SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: ctrl.isLoading.value ? null : ctrl.updateProfile, icon: ctrl.isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.save), label: const Text('Sauvegarder')))),
        ])),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => Get.toNamed('/change-password'), icon: const Icon(Icons.lock), label: const Text('Changer le mot de passe'))),
        const SizedBox(height: 40),
      ])),
    );
  }
}