import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.profile),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'KBS BUILDING',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Get.offNamed(AppRoutes.dashboard),
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('Biens'),
              onTap: () => Get.toNamed(AppRoutes.biens),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () => authController.logout(),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.dashboard.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final biens = controller.dashboard['biens'] ?? {};
        final financier = controller.dashboard['financier'] ?? {};
        final maintenance = controller.dashboard['maintenance'] ?? {};

        return RefreshIndicator(
          onRefresh: controller.loadDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: 'Total biens',
                value: '${biens['total_biens'] ?? 0}',
                icon: Icons.home_work,
              ),
              _StatCard(
                title: 'Biens disponibles',
                value: '${biens['biens_disponibles'] ?? 0}',
                icon: Icons.check_circle,
              ),
              _StatCard(
                title: 'Biens occupés',
                value: '${biens['biens_occupes'] ?? 0}',
                icon: Icons.key,
              ),
              _StatCard(
                title: 'Revenus mois courant',
                value: '${financier['revenus_mois_courant'] ?? 0} USD',
                icon: Icons.attach_money,
              ),
              _StatCard(
                title: 'Tickets maintenance',
                value: '${maintenance['total_tickets'] ?? 0}',
                icon: Icons.build,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 34),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}