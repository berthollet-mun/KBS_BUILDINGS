// lib/views/paiements/paiements_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/paiement_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/status_badge.dart';

class PaiementsListPage extends StatefulWidget {
  const PaiementsListPage({super.key});

  @override
  State<PaiementsListPage> createState() => _PaiementsListPageState();
}

class _PaiementsListPageState extends State<PaiementsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PaiementController ctrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ctrl = Get.put(PaiementController());
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
        title: const Text('Suivi des Loyers'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/echeances-en-retard'),
            icon: const Icon(Icons.warning_amber_rounded),
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
            Tab(text: 'En Attente'),
            Tab(text: 'Payés'),
            Tab(text: 'En Retard'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── RÉSUMÉ FINANCIER DU MOIS ──
          _buildMonthlySummary(),

          // ── TAB CONTENT ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaiementsList('en_attente'),
                _buildPaiementsList('valide'),
                _buildPaiementsList('en_retard'),
              ],
            ),
          ),
        ],
      ),
      // ── BOUTON AJOUTER PAIEMENT ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed('/paiement-create'),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Ajouter un Paiement',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySummary() {
    return Obx(() {
      final totalPaiements = ctrl.paiementsList.length;
      double totalPaye = 0;
      for (var p in ctrl.paiementsList) {
        if (p.statut == 'valide') {
          totalPaye += p.montant;
        }
      }

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A3C6E), Color(0xFF2B5EA7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getCurrentMonth(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalPaiements paiements',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payé',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${totalPaye.toStringAsFixed(0)} USD',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impayés',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '0 USD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaiementsList(String filter) {
    return Obx(() {
      if (ctrl.isLoading.value && ctrl.paiementsList.isEmpty) {
        return const LoadingWidget();
      }
      if (ctrl.paiementsList.isEmpty) {
        return EmptyState(
          icon: Icons.payments_outlined,
          title: 'Aucun paiement',
          buttonText: 'Ajouter un paiement',
          onButtonPressed: () => Get.toNamed('/paiement-create'),
        );
      }

      final filtered = ctrl.paiementsList.where((p) {
        if (filter == 'en_retard') return false; // No retard in paiements
        if (filter == 'en_attente') return p.statut == 'en_attente';
        return p.statut == 'valide';
      }).toList();

      if (filtered.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined,
                  size: 50, color: AppTheme.textSecondary),
              SizedBox(height: 12),
              Text('Aucun paiement dans cette catégorie',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.fetchPaiements(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final p = filtered[i];
            return _buildLocatairePaymentCard(p);
          },
        ),
      );
    });
  }

  Widget _buildLocatairePaymentCard(dynamic p) {
    final initials =
        (p.locataireNom ?? 'L').substring(0, 1).toUpperCase();

    Color statusColor;
    String statusLabel;
    if (p.statut == 'valide') {
      statusColor = AppTheme.successColor;
      statusLabel = 'Payé';
    } else if (p.statut == 'en_attente') {
      statusColor = AppTheme.warningColor;
      statusLabel = 'En attente';
    } else {
      statusColor = AppTheme.errorColor;
      statusLabel = 'Impayé';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/paiement-detail', arguments: p.id),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withOpacity(0.12),
              child: Text(
                initials,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.locataireNom ?? p.referencePaiement ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(
                        label: statusLabel,
                        color: statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${p.codeBien ?? ''} • ${AppTheme.getModePaiementLabel(p.modePaiement)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Échéance: ${p.datePaiement ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Montant
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${p.montant.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 17,
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
      ),
    );
  }

  String _getCurrentMonth() {
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }
}