// lib/views/dashboard/dashboard_stats_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kbs/controllers/dashboard_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';

class DashboardStatsPage extends StatelessWidget {
  const DashboardStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashCtrl = Get.find<DashboardController>();
    // Fetch stats on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashCtrl.fetchStats();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Period selector
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => _showPeriodPicker(context, dashCtrl),
              icon: const Icon(Icons.calendar_today,
                  color: Colors.white, size: 18),
              label: const Text(
                'Période',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (dashCtrl.isStatsLoading.value) {
          return const LoadingWidget(message: 'Chargement des statistiques...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== STAT CARDS ROW =====
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      title: 'Revenus',
                      value:
                          '${dashCtrl.statsRevenusTotaux.toStringAsFixed(0)} USD',
                      subtitle: 'Total sur la période',
                      icon: Icons.trending_up_rounded,
                      color: AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      title: "Taux d'Occupation",
                      value:
                          '${dashCtrl.tauxOccupation.toStringAsFixed(0)}%',
                      subtitle: 'Biens occupés',
                      icon: Icons.pie_chart_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      title: 'Biens Occupés',
                      value: '${dashCtrl.biensOccupes}',
                      subtitle: 'sur ${dashCtrl.totalBiens}',
                      icon: Icons.home_rounded,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      title: 'Loyers Impayés',
                      value: '${dashCtrl.totalEcheancesEnRetard}',
                      subtitle: 'en retard',
                      icon: Icons.warning_amber_rounded,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== BAR CHART - REVENUE EVOLUTION =====
              const Text(
                'Évolution des Revenus',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                child: SizedBox(
                  height: 200,
                  child: _buildRevenueBarChart(dashCtrl),
                ),
              ),

              const SizedBox(height: 24),

              // ===== PIE CHART - RÉPARTITION DES BIENS =====
              const Text(
                'Répartition des Biens',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                    SizedBox(
                      height: 200,
                      child: _buildPieChart(dashCtrl),
                    ),
                    const SizedBox(height: 16),
                    // Légende
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildLegendItem('Disponible',
                            AppTheme.disponibleColor, dashCtrl.biensDisponibles),
                        _buildLegendItem(
                            'Occupé', AppTheme.occupeColor, dashCtrl.biensOccupes),
                        _buildLegendItem('Maintenance',
                            AppTheme.maintenanceColor, dashCtrl.biensMaintenance),
                        _buildLegendItem(
                            'Vendu', AppTheme.venduColor, dashCtrl.biensVendus),
                        _buildLegendItem(
                            'Réservé', AppTheme.reserveColor, dashCtrl.biensReserves),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== TOP BIENS RENTABLES =====
              const Text(
                'Top 5 des Biens Rentables',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...dashCtrl.topBiensRentables.take(5).toList().asMap().entries.map(
                    (entry) => _buildTopBienCard(
                      rank: entry.key + 1,
                      bien: entry.value,
                    ),
                  ),

              // If no top biens data
              if (dashCtrl.topBiensRentables.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Aucune donnée de biens rentables',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // ── STAT BOX ──
  Widget _buildStatBox({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── BAR CHART ──
  Widget _buildRevenueBarChart(DashboardController ctrl) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'];
    final historique = ctrl.historiqueMensuel;

    List<double> values = [];
    for (int i = 0; i < 6; i++) {
      if (i < historique.length) {
        values.add(historique[i].totalEncaisse);
      } else {
        values.add(0);
      }
    }

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final maxY = maxVal > 0 ? maxVal * 1.3 : 100.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)} USD',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
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
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(6, (i) {
          final isHighlighted = i == (historique.length - 1).clamp(0, 5);
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                color: isHighlighted
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor.withOpacity(0.35),
                width: 22,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── PIE CHART ──
  Widget _buildPieChart(DashboardController ctrl) {
    final data = [
      _PieData('Disponible', ctrl.biensDisponibles.toDouble(),
          AppTheme.disponibleColor),
      _PieData(
          'Occupé', ctrl.biensOccupes.toDouble(), AppTheme.occupeColor),
      _PieData('Maintenance', ctrl.biensMaintenance.toDouble(),
          AppTheme.maintenanceColor),
      _PieData('Vendu', ctrl.biensVendus.toDouble(), AppTheme.venduColor),
      _PieData('Réservé', ctrl.biensReserves.toDouble(),
          AppTheme.reserveColor),
    ].where((d) => d.value > 0).toList();

    if (data.isEmpty) {
      return const Center(
        child: Text('Aucune donnée',
            style: TextStyle(color: AppTheme.textSecondary)),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: data
            .map((d) => PieChartSectionData(
                  color: d.color,
                  value: d.value,
                  title: '${d.value.toInt()}',
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  radius: 55,
                ))
            .toList(),
      ),
    );
  }

  // ── LEGEND ITEM ──
  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // ── TOP BIEN CARD ──
  Widget _buildTopBienCard({required int rank, required dynamic bien}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rank <= 3 ? Colors.white : AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bien.codeBien ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  bien.titreBien ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${bien.totalEncaisse?.toStringAsFixed(0) ?? '0'} USD',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.successColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showPeriodPicker(
      BuildContext context, DashboardController ctrl) {
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
            const Text('Sélectionner la période',
                style: AppTheme.headline3),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      ctrl.selectDateDebut(context);
                    },
                    child: Obx(() => Text(
                          'Du ${_formatDate(ctrl.statsDateDebut.value)}',
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      ctrl.selectDateFin(context);
                    },
                    child: Obx(() => Text(
                          'Au ${_formatDate(ctrl.statsDateFin.value)}',
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  ctrl.fetchStats();
                },
                child: const Text('Appliquer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _PieData {
  final String label;
  final double value;
  final Color color;
  _PieData(this.label, this.value, this.color);
}
