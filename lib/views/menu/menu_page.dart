// lib/views/menu/menu_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/theme_controller.dart';
import 'package:kbs/views/shared/widgets/main_scaffold.dart';
import '../../app/themes/app_theme.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final themeCtrl = Get.find<ThemeController>();
    final mainScaffoldCtrl = Get.find<MainScaffoldController>();

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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryLight,
                      ],
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
            _menuItem(Icons.apartment_rounded, 'Mes Biens', () {
              mainScaffoldCtrl.changeTab(1);
            }, AppTheme.primaryColor),
            _menuItem(Icons.payments_rounded, 'Suivi des Loyers', () {
              mainScaffoldCtrl.changeTab(3);
            }, AppTheme.successColor),
            _menuItem(Icons.map_rounded, 'Carte des Biens', () {
              mainScaffoldCtrl.changeTab(2);
            }, AppTheme.infoColor),
            _menuItem(Icons.qr_code_scanner_rounded, 'Scanner QR Code', () {
              Get.toNamed('/qr-scan');
            }, AppTheme.warningColor),
            _menuItem(Icons.build_rounded, 'Maintenance & Pannes', () {
              mainScaffoldCtrl.changeTab(5);
            }, AppTheme.maintenanceColor),
            _menuItem(Icons.bar_chart_rounded, 'Tableau de Bord', () {
              mainScaffoldCtrl.changeTab(6);
            }, const Color(0xFF9B59B6)),

            const SizedBox(height: 20),

            // ── GESTION ──
            if (authCtrl.isAdminOrAgent) ...[
              _sectionTitle('GESTION'),
              _menuItem(Icons.person_rounded, 'Propriétaires', () {
                Get.toNamed('/proprietaires');
              }, AppTheme.primaryColor),
              _menuItem(Icons.groups_rounded, 'Locataires', () {
                Get.toNamed('/locataires');
              }, AppTheme.successColor),
              _menuItem(Icons.description_rounded, 'Contrats de Bail', () {
                Get.toNamed('/contrats');
              }, AppTheme.infoColor),
              _menuItem(Icons.people_rounded, 'Utilisateurs', () {
                Get.toNamed('/users');
              }, AppTheme.warningColor),
              _menuItem(Icons.bar_chart_rounded, 'Rapports & Export', () {
                mainScaffoldCtrl.changeTab(6);
              }, const Color(0xFF9B59B6)),
              _menuItem(Icons.settings_rounded, 'Paramètres', () {
                Get.toNamed('/configurations');
              }, AppTheme.textSecondary),
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
            _menuItem(Icons.help_outline_rounded, 'Centre d\'aide', () {},
                AppTheme.textSecondary),
            _menuItem(Icons.contact_support_outlined, 'Nous contacter', () {},
                AppTheme.textSecondary),

            const SizedBox(height: 32),

            // ── DÉCONNEXION ──
            _menuItem(Icons.logout_rounded, 'Se Déconnecter', () {
              _showLogoutConfirmation(context, authCtrl);
            }, AppTheme.errorColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppTheme.textSecondary.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuItem(
      IconData icon, String title, VoidCallback onTap, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textSecondary.withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItemSwitch(
      IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.textSecondary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, AuthController authCtrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => authCtrl.logout(),
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}