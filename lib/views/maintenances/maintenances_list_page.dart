// lib/views/maintenances/maintenances_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/maintenance_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class MaintenancesListPage extends StatefulWidget {
  const MaintenancesListPage({super.key});

  @override
  State<MaintenancesListPage> createState() => _MaintenancesListPageState();
}

class _MaintenancesListPageState extends State<MaintenancesListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MaintenanceController ctrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ctrl = Get.put(MaintenanceController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance & Pannes'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/maintenance-create'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Tickets'),
            Tab(text: 'Historique'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── STATS BADGES ──
          Obx(() => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildStatBadge(
                      'En attente',
                      '${ctrl.maintenancesList.where((m) => m.statut == 'en_attente').length}',
                      AppTheme.warningColor,
                      Icons.hourglass_top_rounded,
                    ),
                    const SizedBox(width: 8),
                    _buildStatBadge(
                      'En cours',
                      '${ctrl.maintenancesList.where((m) => m.statut == 'en_cours').length}',
                      AppTheme.infoColor,
                      Icons.engineering_rounded,
                    ),
                    const SizedBox(width: 8),
                    _buildStatBadge(
                      'Terminés',
                      '${ctrl.maintenancesList.where((m) => m.statut == 'terminee').length}',
                      AppTheme.successColor,
                      Icons.check_circle_rounded,
                    ),
                  ],
                ),
              )),

          // ── FILTER CHIPS ──
          SizedBox(
            height: 44,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildChip('Tous', ctrl.selectedStatut.value == null,
                        () => ctrl.filterByStatut(null)),
                    const SizedBox(width: 8),
                    _buildChip(
                        'En attente',
                        ctrl.selectedStatut.value == 'en_attente',
                        () => ctrl.filterByStatut('en_attente')),
                    const SizedBox(width: 8),
                    _buildChip(
                        'En cours',
                        ctrl.selectedStatut.value == 'en_cours',
                        () => ctrl.filterByStatut('en_cours')),
                    const SizedBox(width: 8),
                    _buildChip(
                        'Terminés',
                        ctrl.selectedStatut.value == 'terminee',
                        () => ctrl.filterByStatut('terminee')),
                  ],
                )),
          ),

          const SizedBox(height: 8),

          // ── TICKETS LIST ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTicketsList(false),
                _buildTicketsList(true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList(bool isHistorique) {
    return Obx(() {
      if (ctrl.isLoading.value && ctrl.maintenancesList.isEmpty) {
        return const LoadingWidget();
      }
      if (ctrl.maintenancesList.isEmpty) {
        return EmptyState(
          icon: Icons.build_outlined,
          title: 'Aucun ticket',
          buttonText: 'Nouveau ticket',
          onButtonPressed: () => Get.toNamed('/maintenance-create'),
        );
      }

      final items = ctrl.maintenancesList.where((m) {
        if (isHistorique) {
          return m.statut == 'terminee' || m.statut == 'annulee';
        }
        return m.statut != 'terminee' && m.statut != 'annulee';
      }).toList();

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined,
                  size: 50, color: AppTheme.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Text('Aucun ticket dans cette catégorie',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.fetchMaintenances(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final m = items[i];
            return _buildTicketCard(m);
          },
        ),
      );
    });
  }

  Widget _buildTicketCard(dynamic m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: ctrl.getPrioriteColor(m.priorite),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ticket number + badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                m.numeroTicket ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  StatusBadge(
                    label: AppTheme.getPrioriteLabel(m.priorite),
                    color: ctrl.getPrioriteColor(m.priorite),
                  ),
                  const SizedBox(width: 6),
                  StatusBadge(
                    label: AppTheme.getStatutMaintenanceLabel(m.statut),
                    color: ctrl.getStatutColor(m.statut),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            m.titre ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Type panne + bien
          if (m.typePanne != null)
            Row(
              children: [
                Icon(AppTheme.getTypePanneIcon(m.typePanne),
                    size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  m.typePanne!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (m.codeBien != null) ...[
                  const Text(' • ',
                      style: TextStyle(color: AppTheme.textSecondary)),
                  Text(
                    m.codeBien!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(
      String label, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}