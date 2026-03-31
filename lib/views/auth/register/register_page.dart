// lib/views/auth/register/register_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import '../../../app/themes/app_theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(Icons.home_work, size: 50, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Créer un Compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Formulaire
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Form(
                    key: controller.registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Nom
                        _buildLabel('Nom'),
                        TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            hintText: 'Votre nom',
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Le nom est requis' : null,
                        ),
                        const SizedBox(height: 16),

                        // Prénom
                        _buildLabel('Prénom'),
                        TextFormField(
                          controller: controller.prenomController,
                          decoration: const InputDecoration(
                            hintText: 'Votre prénom',
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Le prénom est requis' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        _buildLabel('Email'),
                        TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'votre@email.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'L\'email est requis';
                            }
                            if (!GetUtils.isEmail(v)) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Téléphone
                        _buildLabel('Téléphone'),
                        TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '+243...',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Le téléphone est requis' : null,
                        ),
                        const SizedBox(height: 16),

                        // Mot de passe
                        _buildLabel('Mot de passe'),
                        Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText:
                                  !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon:
                                    const Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  onPressed: controller
                                      .togglePasswordVisibility,
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Le mot de passe est requis';
                                }
                                if (v.length < 6) {
                                  return 'Minimum 6 caractères';
                                }
                                return null;
                              },
                            )),

                        const SizedBox(height: 32),

                        // Bouton
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.register,
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Créer mon Compte'),
                              ),
                            )),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Déjà un compte ? ',
                              style: TextStyle(
                                  color: AppTheme.textSecondary),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.offAllNamed('/login'),
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}