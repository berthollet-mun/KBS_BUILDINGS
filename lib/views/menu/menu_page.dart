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
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                    style: TextStyle(color: Colors.white, fontSize: 10),
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
            // ── PROFIL UTILISATEUR ──
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A3C6E), Color(0xFF2B5EA7)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          authCtrl.currentUser.value?.nom
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authCtrl.userFullName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                authCtrl.userRole.capitalizeFirst ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'KBS BUILDING',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () => Get.toNamed('/profile'),
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // ── ACCÈS RAPIDE ──
            _sectionTitle('ACCÈS RAPIDE'),
            _menuItem(Icons.apartment_rounded, 'Mes Biens', '/biens',
                AppTheme.primaryColor),
            _menuItem(Icons.payments_rounded, 'Suivi des Loyers',
                '/paiements', AppTheme.successColor),
            _menuItem(Icons.map_rounded, 'Carte des Biens',
                '/carte-biens', AppTheme.infoColor),
            _menuItem(Icons.qr_code_scanner_rounded, 'Scanner QR Code',
                '/qr-scan', AppTheme.warningColor),
            _menuItem(Icons.build_rounded, 'Maintenance & Pannes',
                '/maintenances', AppTheme.maintenanceColor),
            _menuItem(Icons.bar_chart_rounded, 'Tableau de Bord',
                '/dashboard-stats', const Color(0xFF9B59B6)),

            const SizedBox(height: 20),

            // ── GESTION ──
            if (authCtrl.isAdminOrAgent) ...[
              _sectionTitle('GESTION'),
              _menuItem(Icons.person_rounded, 'Propriétaires',
                  '/proprietaires', AppTheme.primaryColor),
              _menuItem(Icons.groups_rounded, 'Locataires',
                  '/locataires', AppTheme.successColor),
              _menuItem(Icons.description_rounded,
                  'Contrats de Bail', '/contrats', AppTheme.infoColor),
              _menuItem(Icons.people_rounded, 'Utilisateurs', '/users',
                  AppTheme.warningColor),
              _menuItem(Icons.bar_chart_rounded,
                  'Rapports & Export', '/dashboard-stats', const Color(0xFF9B59B6)),
              _menuItem(Icons.settings_rounded, 'Paramètres',
                  '/configurations', AppTheme.textSecondary),
              const SizedBox(height: 20),
            ],

            // ── PRÉFÉRENCES ──
            _sectionTitle('PRÉFÉRENCES'),
            Obx(() => _menuItemSwitch(
                  Icons.dark_mode_rounded,
                  'Mode Sombre',
                  themeCtrl.isDarkMode.value,
                  (value) => themeCtrl.toggleTheme(),
                )),

            const SizedBox(height: 20),

            // ── SUPPORT ──
            _sectionTitle('SUPPORT'),
            _menuItem(Icons.help_outline_rounded, "Centre d'aide", null,
                AppTheme.infoColor),
            _menuItem(Icons.chat_bubble_outline_rounded,
                'Nous contacter', null, AppTheme.successColor),

            const SizedBox(height: 24),

            // ── DÉCONNEXION ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(authCtrl),
                icon: const Icon(Icons.logout_rounded,
                    color: AppTheme.errorColor),
                label: const Text(
                  'Se Déconnecter',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
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
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuItem(
      IconData icon, String label, String? route, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            size: 20, color: AppTheme.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        onTap: route != null ? () => Get.toNamed(route) : null,
      ),
    );
  }

  Widget _menuItemSwitch(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryColor,
      ),
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