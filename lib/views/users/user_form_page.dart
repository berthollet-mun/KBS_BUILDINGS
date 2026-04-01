import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/role_controller.dart';
import 'package:kbs/controllers/user_controller.dart';
import '../../app/themes/app_theme.dart';

class UserFormPage extends StatelessWidget {
  final bool isEditing;
  const UserFormPage({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserController>();
    final roleCtrl = Get.put(RoleController());

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier Utilisateur' : 'Nouvel Utilisateur')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: ctrl.formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Informations', style: AppTheme.headline3),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.nomController, decoration: const InputDecoration(labelText: 'Nom *', prefixIcon: Icon(Icons.person)), validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.prenomController, decoration: const InputDecoration(labelText: 'Prénom *', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.postnomController, decoration: const InputDecoration(labelText: 'Postnom', prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.emailController, decoration: const InputDecoration(labelText: 'Email *', prefixIcon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Requis' : null),
        const SizedBox(height: 16),
        TextFormField(controller: ctrl.telephoneController, decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        if (!isEditing) ...[
          TextFormField(controller: ctrl.motDePasseController, decoration: const InputDecoration(labelText: 'Mot de passe *', prefixIcon: Icon(Icons.lock)), obscureText: true, validator: (v) { if (v!.isEmpty) return 'Requis'; if (v.length < 6) return 'Min 6 caractères'; return null; }),
          const SizedBox(height: 16),
        ],
        const Text('Rôle et statut', style: AppTheme.headline3),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<int>(initialValue: ctrl.formRoleId.value, decoration: const InputDecoration(labelText: 'Rôle *', prefixIcon: Icon(Icons.security)), items: roleCtrl.rolesList.map((r) => DropdownMenuItem(value: r.id, child: Text(r.nom ?? ''))).toList(), onChanged: (v) => ctrl.formRoleId.value = v, validator: (v) => v == null ? 'Sélectionnez un rôle' : null)),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(initialValue: ctrl.formStatut.value, decoration: const InputDecoration(labelText: 'Statut', prefixIcon: Icon(Icons.toggle_on)), items: ctrl.statuts.map((s) => DropdownMenuItem(value: s, child: Text(s.capitalizeFirst!))).toList(), onChanged: (v) => ctrl.formStatut.value = v ?? 'actif')),
        const SizedBox(height: 40),
        Obx(() => SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: ctrl.isSaving.value ? null : () => isEditing ? ctrl.updateUser(Get.arguments ?? 0) : ctrl.createUser(), icon: ctrl.isSaving.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(isEditing ? Icons.save : Icons.person_add), label: Text(isEditing ? 'Enregistrer' : 'Créer l\'Utilisateur', style: const TextStyle(fontSize: 16))))),
        const SizedBox(height: 20),
      ]))),
    );
  }
}