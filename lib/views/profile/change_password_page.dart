import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/themes/app_theme.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: ctrl.changePasswordFormKey, child: Column(children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.lock, size: 50, color: AppTheme.primaryColor)),
        const SizedBox(height: 32),
        Obx(() => TextFormField(controller: ctrl.oldPasswordController, obscureText: !ctrl.isPasswordVisible.value, decoration: InputDecoration(labelText: 'Ancien mot de passe *', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: ctrl.togglePasswordVisibility, icon: Icon(ctrl.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility))), validator: (v) => v!.isEmpty ? 'Requis' : null)),
        const SizedBox(height: 16),
        Obx(() => TextFormField(controller: ctrl.newPasswordController, obscureText: !ctrl.isPasswordVisible2.value, decoration: InputDecoration(labelText: 'Nouveau mot de passe *', prefixIcon: const Icon(Icons.lock), suffixIcon: IconButton(onPressed: ctrl.togglePasswordVisibility2, icon: Icon(ctrl.isPasswordVisible2.value ? Icons.visibility_off : Icons.visibility))), validator: (v) { if (v!.isEmpty) return 'Requis'; if (v.length < 6) return 'Min 6 caractères'; return null; })),
        const SizedBox(height: 40),
        Obx(() => SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: ctrl.isLoading.value ? null : ctrl.changePassword, icon: ctrl.isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.check), label: const Text('Changer le mot de passe', style: TextStyle(fontSize: 16))))),
      ]))),
    );
  }
}