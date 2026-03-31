// lib/views/dashboard/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/dashboard_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/stat_card.dart';
import '../shared/widgets/section_header.dart';
import '../shared/widgets/loading_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final dashCtrl = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (dashCtrl.isLoading.value) {
          return const LoadingWidget(message: 'Chargement...');
        }

        return RefreshIndicator(
          onRefresh: dashCtrl.refreshDashboard,
          child: CustomScrollView(
            slivers: [
              // ===== APP BAR =====
              SliverAppBar(
                expandedHeight: 100,
                floating: true,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour ${authCtrl.currentUser.value?.prenom ?? ''} 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'KBS Building',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        // Notification bell
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Get.toNamed('/notifications'),
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            if (dashCtrl.notificationsNonLues > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.errorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${dashCtrl.notificationsNonLues}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== CONTENU =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== STAT CARDS (2x2) =====
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              value: '${dashCtrl.totalBiens}',
                              label: 'Biens Locatifs',
                              color: AppTheme.statCardBlue,
                              icon: Icons.apartment,
                              onTap: () => Get.toNamed('/biens'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              value: '${dashCtrl.biensOccupes}',
                              label: 'Locataires',
                              color: AppTheme.successColor,
                              icon: Icons.people,
                              onTap: () => Get.toNamed('/locataires'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              value:
                                  '${dashCtrl.tauxOccupation.toStringAsFixed(0)}%',
                              label: "Taux d'Occupation",
                              color: AppTheme.statCardOrange,
                              icon: Icons.trending_up,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              value: '${dashCtrl.ticketsEnAttente + dashCtrl.ticketsEnCours}',
                              label: 'Pannes Actives',
                              color: AppTheme.statCardRed,
                              icon: Icons.build,
                              onTap: () =>
                                  Get.toNamed('/maintenances'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ===== REVENUS & DÉPENSES =====
                      SectionHeader(
                        title: 'Revenus & Dépenses',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Ce mois',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      _buildRevenueCard(dashCtrl),

                      const SizedBox(height: 24),

                      // ===== ACTIONS RAPIDES =====
                      const Text(
                        'Actions rapides',
                        style: AppTheme.headline3,
                      ),
                      const SizedBox(height: 12),
                      _buildQuickActions(),

                      const SizedBox(height: 24),

                      // ===== ÉCHÉANCES EN RETARD =====
                      if (dashCtrl.totalEcheancesEnRetard > 0) ...[
                        SectionHeader(
                          title: 'Échéances en retard',
                          actionText: 'Voir tout',
                          onActionTap: () =>
                              Get.toNamed('/echeances-en-retard'),
                        ),
                        ...dashCtrl.echeancesEnRetard
                            .take(3)
                            .map((e) => _buildRetardCard(e)),
                        const SizedBox(height: 24),
                      ],

                      const SizedBox(height: 80), // Space pour bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRevenueCard(DashboardController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenus du mois',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ctrl.revenusMoisCourant.toStringAsFixed(0)} USD',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Barre de progression simple
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ctrl.tauxOccupation / 100,
              backgroundColor: Colors.grey[200],
              color: AppTheme.primaryColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contrats actifs: ${ctrl.contratsActifs}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'Impayés: ${ctrl.totalEcheancesEnRetard}',
                style: TextStyle(
                  fontSize: 12,
                  color: ctrl.totalEcheancesEnRetard > 0
                      ? AppTheme.errorColor
                      : AppTheme.textSecondary,
                  fontWeight: ctrl.totalEcheancesEnRetard > 0
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
          icon: Icons.apartment,
          label: 'Mes Biens',
          color: AppTheme.primaryColor,
          route: '/biens'),
      _QuickAction(
          icon: Icons.payments,
          label: 'Loyers',
          color: AppTheme.successColor,
          route: '/paiements'),
      _QuickAction(
          icon: Icons.map,
          label: 'Carte',
          color: AppTheme.infoColor,
          route: '/biens'),
      _QuickAction(
          icon: Icons.qr_code_scanner,
          label: 'QR Code',
          color: AppTheme.accentColor,
          route: '/qr-scan'),
      _QuickAction(
          icon: Icons.build,
          label: 'Maintenance',
          color: AppTheme.warningColor,
          route: '/maintenances'),
      _QuickAction(
          icon: Icons.bar_chart,
          label: 'Rapports',
          color: AppTheme.primaryLight,
          route: '/dashboard'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => Get.toNamed(action.route),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(action.icon,
                      color: action.color, size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetardCard(dynamic echeance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
        left: BorderSide(
        color: AppTheme.errorColor,
        width: 3,
  ),
),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_amber,
                color: AppTheme.errorColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  echeance.nomLocataire ?? 'Locataire',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${echeance.codeBien} • ${echeance.joursRetard} jours de retard',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${echeance.resteAPayer?.toStringAsFixed(0) ?? '0'} USD',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}