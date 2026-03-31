import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: Obx(() {
        final user = authController.user.value;

        if (authController.isLoading.value && user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (user == null) {
          return const Center(child: Text('Aucun utilisateur connecté'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text('Nom'),
                    subtitle: Text('${user.nom} ${user.postnom ?? ''}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Prénom'),
                    subtitle: Text('${user.prenom ?? '-'}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text('${user.email ?? '-'}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Téléphone'),
                    subtitle: Text('${user.telephone ?? '-'}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Mode sombre'),
                    trailing: Obx(
                      () => Switch(
                        value: themeController.currentTheme.value ==
                            ThemeMode.dark,
                        onChanged: (_) => themeController.toggleTheme(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Déconnexion'),
                    onTap: authController.logout,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}