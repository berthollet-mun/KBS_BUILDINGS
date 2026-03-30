class DashboardStatsModel {
  final DashboardPeriode periode;
  final double revenusTotaux;
  final double depensesMaintenance;
  final double beneficeNet;
  final int nouveauxContrats;
  final int nouveauxBiens;

  DashboardStatsModel({
    required this.periode,
    required this.revenusTotaux,
    required this.depensesMaintenance,
    required this.beneficeNet,
    required this.nouveauxContrats,
    required this.nouveauxBiens,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      periode: DashboardPeriode.fromJson(json['periode'] ?? {}),
      revenusTotaux: _parseDouble(json['revenus_totaux']) ?? 0,
      depensesMaintenance: _parseDouble(json['depenses_maintenance']) ?? 0,
      beneficeNet: _parseDouble(json['benefice_net']) ?? 0,
      nouveauxContrats: json['nouveaux_contrats'] ?? 0,
      nouveauxBiens: json['nouveaux_biens'] ?? 0,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class DashboardPeriode {
  final String debut;
  final String fin;

  DashboardPeriode({
    required this.debut,
    required this.fin,
  });

  factory DashboardPeriode.fromJson(Map<String, dynamic> json) {
    return DashboardPeriode(
      debut: json['debut'] ?? '',
      fin: json['fin'] ?? '',
    );
  }
}