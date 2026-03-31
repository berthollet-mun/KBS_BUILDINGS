// lib/views/shared/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/themes/app_theme.dart';
import '../../dashboard/dashboard_page.dart';
import '../../biens/biens_list_page.dart';
import '../../paiements/paiements_list_page.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MainScaffoldController());

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              DashboardPage(),
              BiensListPage(),
              SizedBox(), // Placeholder pour le FAB
              PaiementsListPage(),
              MenuPage(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context, controller),
          floatingActionButton: _buildFAB(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  Widget _buildBottomNav(
      BuildContext context, _MainScaffoldController controller) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: Theme.of(context).cardColor,
            elevation: 0,
            child: SizedBox(
              height: 60,
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
                  const SizedBox(width: 48), // Space pour le FAB
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
        ));
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required _MainScaffoldController controller,
  }) {
    final isActive = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppTheme.primaryColor
                  : AppTheme.bottomNavInactive,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
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
    return FloatingActionButton(
      onPressed: () => _showQuickActions(context),
      backgroundColor: AppTheme.primaryColor,
      elevation: 6,
      child: const Icon(Icons.add, size: 28, color: Colors.white),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Action rapide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickActionItem(
                  icon: Icons.add_home,
                  label: 'Nouveau Bien',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/bien-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.payment,
                  label: 'Paiement',
                  color: AppTheme.successColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/paiement-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.build,
                  label: 'Ticket',
                  color: AppTheme.warningColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/maintenance-create');
                  },
                ),
                _quickActionItem(
                  icon: Icons.description,
                  label: 'Contrat',
                  color: AppTheme.infoColor,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/contrat-create');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _MainScaffoldController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    if (index != 2) {
      // Skip le FAB index
      currentIndex.value = index;
    }
  }
}