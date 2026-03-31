// lib/app/controllers/dashboard_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/dashboard_service.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/dashboard_stats_model.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = Get.find<DashboardService>();

  // --- État réactif ---
  final isLoading = true.obs;
  final isStatsLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<DashboardModel?> dashboardData = Rx<DashboardModel?>(null);
  final Rx<DashboardStatsModel?> statsData = Rx<DashboardStatsModel?>(null);

  // --- Filtres de statistiques ---
  final Rx<DateTime> statsDateDebut = DateTime(DateTime.now().year, 1, 1).obs;
  final Rx<DateTime> statsDateFin = DateTime(DateTime.now().year, 12, 31).obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Récupère toutes les données du dashboard
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _dashboardService.getDashboard();
      if (result.success) {
        dashboardData.value = _dashboardService.parseDashboard(result);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      errorMessage.value =
          "Impossible de charger les données du tableau de bord.";
    } finally {
      isLoading.value = false;
    }
  }

  /// Récupère les statistiques par période
  Future<void> fetchStats() async {
    isStatsLoading.value = true;
    try {
      final result = await _dashboardService.getStats(
        dateDebut: _formatDate(statsDateDebut.value),
        dateFin: _formatDate(statsDateFin.value),
      );
      if (result.success) {
        statsData.value = _dashboardService.parseStats(result);
      } else {
        Get.snackbar('Erreur', result.message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les statistiques',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isStatsLoading.value = false;
    }
  }

  /// Rafraîchir tout le dashboard
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
    await fetchStats();
  }

  /// Sélecteur de date pour les stats
  Future<void> selectDateDebut(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: statsDateDebut.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      statsDateDebut.value = picked;
      await fetchStats();
    }
  }

  Future<void> selectDateFin(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: statsDateFin.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      statsDateFin.value = picked;
      await fetchStats();
    }
  }

  // --- Getters pratiques (TOUS CORRIGÉS) ---

  // Biens
  int get totalBiens => dashboardData.value?.biens.totalBiens ?? 0;
  int get biensDisponibles => dashboardData.value?.biens.biensDisponibles ?? 0;
  int get biensOccupes => dashboardData.value?.biens.biensOccupes ?? 0;
  int get biensMaintenance => dashboardData.value?.biens.biensMaintenance ?? 0;
  int get biensVendus => dashboardData.value?.biens.biensVendus ?? 0;
  int get biensReserves => dashboardData.value?.biens.biensReserves ?? 0;
  int get totalMaisons => dashboardData.value?.biens.totalMaisons ?? 0;
  int get totalAppartements => dashboardData.value?.biens.totalAppartements ?? 0;
  int get totalParcelles => dashboardData.value?.biens.totalParcelles ?? 0;
  int get totalBureaux => dashboardData.value?.biens.totalBureaux ?? 0;

  // Financier
  double get revenusMoisCourant =>
      dashboardData.value?.financier.revenusMoisCourant ?? 0;
  List<HistoriqueMensuel> get historiqueMensuel =>
      dashboardData.value?.financier.historiqueMensuel ?? [];

  // Contrats
  int get contratsActifs => dashboardData.value?.contrats.actifs ?? 0;
  int get contratsExpirantBientot =>
      dashboardData.value?.contrats.expirantBientot ?? 0;

  // Échéances en retard
  List<DashboardEcheanceRetard> get echeancesEnRetard =>
      dashboardData.value?.echeancesEnRetard ?? [];
  int get totalEcheancesEnRetard => echeancesEnRetard.length;

  // Maintenance
  int get totalTickets => dashboardData.value?.maintenance.totalTickets ?? 0;
  int get ticketsEnAttente => dashboardData.value?.maintenance.enAttente ?? 0;
  int get ticketsAssignes => dashboardData.value?.maintenance.assignes ?? 0;
  int get ticketsEnCours => dashboardData.value?.maintenance.enCours ?? 0;
  int get ticketsTermines => dashboardData.value?.maintenance.termines ?? 0;
  int get ticketsAnnules => dashboardData.value?.maintenance.annules ?? 0;
  int get ticketsUrgents =>
      dashboardData.value?.maintenance.urgentsOuverts ?? 0;
  double get coutTotalMaintenance =>
      dashboardData.value?.maintenance.coutTotalMaintenance ?? 0; // ✅ CORRIGÉ

  // Visites
  int get visitesPlanifiees =>
      dashboardData.value?.visitesPlanifiees ?? 0; // ✅ CORRIGÉ (P majuscule)

  // Top biens
  List<DashboardBienRentable> get topBiensRentables =>
      dashboardData.value?.topBiensRentables ?? [];

  // Notifications
  int get notificationsNonLues =>
      dashboardData.value?.notificationsNonLues ?? 0;

  // Taux d'occupation
  double get tauxOccupation => dashboardData.value?.tauxOccupation ?? 0;

  // --- Stats getters ---
  double get statsRevenusTotaux => statsData.value?.revenusTotaux ?? 0;
  double get statsDepensesMaintenance =>
      statsData.value?.depensesMaintenance ?? 0;
  double get statsBeneficeNet => statsData.value?.beneficeNet ?? 0;
  int get statsNouveauxContrats => statsData.value?.nouveauxContrats ?? 0;
  int get statsNouveauxBiens => statsData.value?.nouveauxBiens ?? 0;

  // --- Helpers ---
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}