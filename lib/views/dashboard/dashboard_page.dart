// lib/views/dashboard/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/dashboard_controller.dart';
import '../../app/themes/app_theme.dart';
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
                expandedHeight: 110,
                floating: true,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A3C6E),
                          Color(0xFF2B5EA7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 12),
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => Get.toNamed('/notifications'),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            if (dashCtrl.notificationsNonLues > 0)
                              Positioned(
                                right: 6,
                                top: 6,
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
                      // ===== 4 STAT CARDS (2x2) =====
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              value: '${dashCtrl.totalBiens}',
                              label: 'Biens Locatifs',
                              color: const Color(0xFF1A3C6E),
                              icon: Icons.apartment_rounded,
                              onTap: () => Get.toNamed('/biens'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              value: '${dashCtrl.biensOccupes}',
                              label: 'Locataires',
                              color: const Color(0xFF27AE60),
                              icon: Icons.people_rounded,
                              onTap: () => Get.toNamed('/locataires'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              value: '${dashCtrl.tauxOccupation.toStringAsFixed(0)}%',
                              label: "Taux d'Occupation",
                              color: const Color(0xFFF39C12),
                              icon: Icons.trending_up_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              value: '${dashCtrl.ticketsEnAttente + dashCtrl.ticketsEnCours}',
                              label: 'Pannes Actives',
                              color: const Color(0xFFE74C3C),
                              icon: Icons.build_rounded,
                              onTap: () => Get.toNamed('/maintenances'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ===== REVENUS & DÉPENSES AVEC GRAPHIQUE =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Revenus & Dépenses',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
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
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRevenueChart(dashCtrl),

                      const SizedBox(height: 24),

                      // ===== ACTIONS RAPIDES =====
                      const Text(
                        'Actions rapides',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildQuickActions(),

                      const SizedBox(height: 24),

                      // ===== ÉCHÉANCES EN RETARD =====
                      if (dashCtrl.totalEcheancesEnRetard > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Échéances en retard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed('/echeances-en-retard'),
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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

  // ── STAT CARD ──
  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ── REVENUE CHART ──
  Widget _buildRevenueChart(DashboardController ctrl) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'];
    final historique = ctrl.historiqueMensuel;

    // Build bar data from historique
    List<double> values = [];
    for (int i = 0; i < 6; i++) {
      if (i < historique.length) {
        values.add(historique[i].totalEncaisse);
      } else {
        values.add(0);
      }
    }
    // If all zeros, use some dummy data for visual
    if (values.every((v) => v == 0)) {
      values = [0, 0, 0, 0, 0, 0];
    }

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final maxY = maxVal > 0 ? maxVal * 1.3 : 100.0;

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
          // Revenue summary row
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
                      fontSize: 22,
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
                  Icons.trending_up_rounded,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bar chart
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[idx],
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(6, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: i == 5
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.4),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Summary row
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

  // ── QUICK ACTIONS GRID ──
  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.apartment_rounded,
        label: 'Mes Biens',
        color: const Color(0xFF1A3C6E),
        route: '/biens',
      ),
      _QuickAction(
        icon: Icons.payments_rounded,
        label: 'Loyers',
        color: const Color(0xFF27AE60),
        route: '/paiements',
      ),
      _QuickAction(
        icon: Icons.map_rounded,
        label: 'Carte',
        color: const Color(0xFF3498DB),
        route: '/carte-biens',
      ),
      _QuickAction(
        icon: Icons.qr_code_scanner_rounded,
        label: 'QR Code',
        color: const Color(0xFFF39C12),
        route: '/qr-scan',
      ),
      _QuickAction(
        icon: Icons.build_rounded,
        label: 'Maintenance',
        color: const Color(0xFFE67E22),
        route: '/maintenances',
      ),
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: 'Rapports',
        color: const Color(0xFF9B59B6),
        route: '/dashboard-stats',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.05,
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

  // ── RETARD CARD ──
  Widget _buildRetardCard(dynamic echeance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: const Border(
          left: BorderSide(
            color: AppTheme.errorColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: AppTheme.errorColor, size: 22),
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
                const SizedBox(height: 2),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${echeance.resteAPayer?.toStringAsFixed(0) ?? '0'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorColor,
                  fontSize: 16,
                ),
              ),
              const Text(
                'USD',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
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