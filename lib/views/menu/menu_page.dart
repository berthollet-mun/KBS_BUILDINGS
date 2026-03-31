// lib/views/menu/menu_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/theme_controller.dart';
import '../../app/themes/app_theme.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final themeCtrl = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => Get.toNamed('/notifications'),
                icon: const Icon(Icons.notifications_outlined),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                        color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil utilisateur
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [AppTheme.cardShadow],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          authCtrl.currentUser.value?.nom
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              authCtrl.userFullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              authCtrl.userRole.capitalizeFirst ??
                                  '',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'KBS BUILDING',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed('/profile'),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // ACCÈS RAPIDE
            _sectionTitle('ACCÈS RAPIDE'),
            _menuItem(Icons.apartment, 'Mes Biens', '/biens'),
            _menuItem(Icons.payments, 'Suivi des Loyers', '/paiements'),
            _menuItem(Icons.map, 'Carte des Biens', '/biens'),
            _menuItem(Icons.qr_code_scanner, 'Scanner QR Code', '/qr-scan'),
            _menuItem(Icons.build, 'Maintenance & Pannes', '/maintenances'),
            _menuItem(Icons.dashboard, 'Tableau de Bord', '/dashboard'),

            const SizedBox(height: 20),

            // GESTION
            if (authCtrl.isAdminOrAgent) ...[
              _sectionTitle('GESTION'),
              _menuItem(Icons.person, 'Propriétaires', '/proprietaires'),
              _menuItem(Icons.groups, 'Locataires', '/locataires'),
              _menuItem(Icons.description, 'Contrats de Bail', '/contrats'),
              _menuItem(Icons.people, 'Utilisateurs', '/users'),
              _menuItem(Icons.bar_chart, 'Rapports & Export', '/dashboard'),
              _menuItem(Icons.settings, 'Paramètres', '/configurations'),
              const SizedBox(height: 20),
            ],

            // PRÉFÉRENCES
            _sectionTitle('PRÉFÉRENCES'),
            Obx(() => _menuItemSwitch(
                  Icons.dark_mode,
                  'Mode Sombre',
                  themeCtrl.isDarkMode.value,
                  (value) => themeCtrl.toggleTheme(),
                )),

            const SizedBox(height: 20),

            // SUPPORT
            _sectionTitle('SUPPORT'),
            _menuItem(Icons.help_outline, "Centre d'aide", null),
            _menuItem(Icons.chat_bubble_outline, 'Nous contacter', null),

            const SizedBox(height: 24),

            // Déconnexion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(authCtrl),
                icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                label: const Text(
                  'Se Déconnecter',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, String? route) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
      onTap: route != null ? () => Get.toNamed(route) : null,
    );
  }

  Widget _menuItemSwitch(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      trailing: Switch(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void _confirmLogout(AuthController authCtrl) {
    Get.defaultDialog(
      title: 'Déconnexion',
      middleText: 'Voulez-vous vraiment vous déconnecter ?',
      textCancel: 'Annuler',
      textConfirm: 'Se déconnecter',
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.errorColor,
      onConfirm: () {
        Get.back();
        authCtrl.logout();
      },
    );
  }
}