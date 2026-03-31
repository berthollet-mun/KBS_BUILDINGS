import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.home_work, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Bienvenue sur KBS BUILDING',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Plateforme intelligente de gestion immobilière',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.register),
                  child: const Text('Créer un compte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}