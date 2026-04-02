// lib/views/shared/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/views/menu/menu_page.dart';
import '../../../app/themes/app_theme.dart';
import '../../dashboard/dashboard_page.dart';
import '../../biens/biens_list_page.dart';
import '../../paiements/paiements_list_page.dart';
import '../../biens/carte_biens_page.dart';
import '../../maintenances/maintenances_list_page.dart';
import '../../dashboard/dashboard_stats_page.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScaffoldController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.currentIndex.value != 0) {
          controller.changeTab(0);
        } else {
          // Si on est déjà sur l'accueil, on peut quitter l'app (ou afficher une confirmation)
          final bool shouldExit = await _showExitConfirmation(context);
          if (shouldExit) {
            Get.back();
          }
        }
      },
      child: Obx(() => Scaffold(
            body: IndexedStack(
              index: controller.currentIndex.value,
              children: const [
                DashboardPage(),
                BiensListPage(),
                CarteBiensPage(),
                PaiementsListPage(),
                MenuPage(),
                MaintenancesListPage(),
                DashboardStatsPage(),
              ],
            ),
            bottomNavigationBar: _buildBottomNav(context, controller),
          )),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quitter'),
            content: const Text('Voulez-vous vraiment quitter l\'application ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Quitter'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildBottomNav(
      BuildContext context, MainScaffoldController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
                index: 0,
                controller: controller,
              ),
              _buildNavItem(
                icon: Icons.apartment_outlined,
                activeIcon: Icons.apartment,
                label: 'Biens',
                index: 1,
                controller: controller,
              ),
              _buildCenterItem(context, controller),
              _buildNavItem(
                icon: Icons.payments_outlined,
                activeIcon: Icons.payments,
                label: 'Loyers',
                index: 3,
                controller: controller,
              ),
              _buildNavItem(
                icon: Icons.menu,
                activeIcon: Icons.menu,
                label: 'Menu',
                index: 4,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterItem(
      BuildContext context, MainScaffoldController controller) {
    final isCarteActive = controller.currentIndex.value == 2;

    return GestureDetector(
      onTap: () {
        if (isCarteActive) {
          // Déjà sur la carte, on peut ouvrir les actions ou rester là
          _showQuickActions(context);
        } else {
          // On change vers l'onglet carte
          controller.changeTab(2);
        }
      },
      onLongPress: () => _showQuickActions(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCarteActive ? AppTheme.primaryColor : AppTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              isCarteActive ? Icons.map : Icons.add,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isCarteActive ? 'Carte' : 'Action',
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCarteActive ? FontWeight.w600 : FontWeight.w400,
              color: isCarteActive
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required MainScaffoldController controller,
  }) {
    final isActive = controller.currentIndex.value == index;
    // Si on est sur maintenance (5) ou stats (6), on peut mettre en avant Menu (4) ou Accueil (0)
    final isEffectiveActive = isActive ||
        (index == 0 && controller.currentIndex.value == 6) ||
        (index == 4 && controller.currentIndex.value == 5);

    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEffectiveActive ? activeIcon : icon,
              color: isEffectiveActive
                  ? AppTheme.primaryColor
                  : AppTheme.bottomNavInactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isEffectiveActive ? FontWeight.w600 : FontWeight.w400,
                color: isEffectiveActive
                    ? AppTheme.primaryColor
                    : AppTheme.bottomNavInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    // Supprimé car intégré dans _buildBottomNav pour plus de contrôle
    return const SizedBox.shrink();
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Actions Rapides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _quickActionItem(
                  icon: Icons.add_home_work_outlined,
                  label: 'Nouveau Bien',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/bien-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.person_add_outlined,
                  label: 'Nouveau Locataire',
                  color: AppTheme.successColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/locataire-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.assignment_outlined,
                  label: 'Nouveau Contrat',
                  color: AppTheme.infoColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/contrat-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.build_outlined,
                  label: 'Nouveau Ticket',
                  color: AppTheme.warningColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/maintenance-create');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color.darken(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScaffoldController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsv = HSVColor.fromColor(this);
    final darkenedHsv = hsv.withValue((hsv.value - amount).clamp(0.0, 1.0));
    return darkenedHsv.toColor();
  }
}
