class DashboardModel {
  final DashboardBiens biens;
  final DashboardFinancier financier;
  final DashboardContrats contrats;
  final List<DashboardEcheanceRetard> echeancesEnRetard;
  final DashboardMaintenance maintenance;
  final int visitesplanifiees;
  final List<DashboardBienRentable> topBiensRentables;
  final int notificationsNonLues;

  DashboardModel({
    required this.biens,
    required this.financier,
    required this.contrats,
    required this.echeancesEnRetard,
    required this.maintenance,
    required this.visitesplanifiees,
    required this.topBiensRentables,
    required this.notificationsNonLues,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      biens: DashboardBiens.fromJson(json['biens'] ?? {}),
      financier: DashboardFinancier.fromJson(json['financier'] ?? {}),
      contrats: DashboardContrats.fromJson(json['contrats'] ?? {}),
      echeancesEnRetard: json['echeances_en_retard'] != null
          ? (json['echeances_en_retard'] as List)
              .map((e) => DashboardEcheanceRetard.fromJson(e))
              .toList()
          : [],
      maintenance: DashboardMaintenance.fromJson(json['maintenance'] ?? {}),
      visitesplanifiees: json['visites_planifiees'] ?? 0,
      topBiensRentables: json['top_biens_rentables'] != null
          ? (json['top_biens_rentables'] as List)
              .map((e) => DashboardBienRentable.fromJson(e))
              .toList()
          : [],
      notificationsNonLues: json['notifications_non_lues'] ?? 0,
    );
  }

  double get tauxOccupation {
    if (biens.totalBiens == 0) return 0;
    return (biens.biensOccupes / biens.totalBiens) * 100;
  }
}

class DashboardBiens {
  final int totalBiens;
  final int biensDisponibles;
  final int biensOccupes;
  final int biensMaintenance;
  final int biensVendus;
  final int biensReserves;
  final int totalMaisons;
  final int totalAppartements;
  final int totalParcelles;
  final int totalBureaux;

  DashboardBiens({
    required this.totalBiens,
    required this.biensDisponibles,
    required this.biensOccupes,
    required this.biensMaintenance,
    required this.biensVendus,
    required this.biensReserves,
    required this.totalMaisons,
    required this.totalAppartements,
    required this.totalParcelles,
    required this.totalBureaux,
  });

  factory DashboardBiens.fromJson(Map<String, dynamic> json) {
    return DashboardBiens(
      totalBiens: json['total_biens'] ?? 0,
      biensDisponibles: json['biens_disponibles'] ?? 0,
      biensOccupes: json['biens_occupes'] ?? 0,
      biensMaintenance: json['biens_maintenance'] ?? 0,
      biensVendus: json['biens_vendus'] ?? 0,
      biensReserves: json['biens_reserves'] ?? 0,
      totalMaisons: json['total_maisons'] ?? 0,
      totalAppartements: json['total_appartements'] ?? 0,
      totalParcelles: json['total_parcelles'] ?? 0,
      totalBureaux: json['total_bureaux'] ?? 0,
    );
  }
}

class DashboardFinancier {
  final double revenusMoisCourant;
  final List<HistoriqueMensuel> historiqueMensuel;

  DashboardFinancier({
    required this.revenusMoisCourant,
    required this.historiqueMensuel,
  });

  factory DashboardFinancier.fromJson(Map<String, dynamic> json) {
    return DashboardFinancier(
      revenusMoisCourant: _parseDouble(json['revenus_mois_courant']) ?? 0,
      historiqueMensuel: json['historique_mensuel'] != null
          ? (json['historique_mensuel'] as List)
              .map((e) => HistoriqueMensuel.fromJson(e))
              .toList()
          : [],
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

class HistoriqueMensuel {
  final String mois;
  final int nombrePaiements;
  final double totalEncaisse;

  HistoriqueMensuel({
    required this.mois,
    required this.nombrePaiements,
    required this.totalEncaisse,
  });

  factory HistoriqueMensuel.fromJson(Map<String, dynamic> json) {
    return HistoriqueMensuel(
      mois: json['mois'] ?? '',
      nombrePaiements: json['nombre_paiements'] ?? 0,
      totalEncaisse: _parseDouble(json['total_encaisse']) ?? 0,
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

class DashboardContrats {
  final int actifs;
  final int expirantBientot;

  DashboardContrats({
    required this.actifs,
    required this.expirantBientot,
  });

  factory DashboardContrats.fromJson(Map<String, dynamic> json) {
    return DashboardContrats(
      actifs: json['actifs'] ?? 0,
      expirantBientot: json['expirant_bientot'] ?? 0,
    );
  }
}

class DashboardEcheanceRetard {
  final int echeanceId;
  final String dateEcheance;
  final double montantAttendu;
  final double resteAPayer;
  final int joursRetard;
  final String numeroContrat;
  final String codeBien;
  final String nomLocataire;

  DashboardEcheanceRetard({
    required this.echeanceId,
    required this.dateEcheance,
    required this.montantAttendu,
    required this.resteAPayer,
    required this.joursRetard,
    required this.numeroContrat,
    required this.codeBien,
    required this.nomLocataire,
  });

  factory DashboardEcheanceRetard.fromJson(Map<String, dynamic> json) {
    return DashboardEcheanceRetard(
      echeanceId: json['echeance_id'] ?? 0,
      dateEcheance: json['date_echeance'] ?? '',
      montantAttendu: _parseDouble(json['montant_attendu']) ?? 0,
      resteAPayer: _parseDouble(json['reste_a_payer']) ?? 0,
      joursRetard: json['jours_retard'] ?? 0,
      numeroContrat: json['numero_contrat'] ?? '',
      codeBien: json['code_bien'] ?? '',
      nomLocataire: json['nom_locataire'] ?? '',
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

class DashboardMaintenance {
  final int totalTickets;
  final int enAttente;
  final int assignes;
  final int enCours;
  final int termines;
  final int annules;
  final int urgentsOuverts;
  final double coutTotalMaintenance;

  DashboardMaintenance({
    required this.totalTickets,
    required this.enAttente,
    required this.assignes,
    required this.enCours,
    required this.termines,
    required this.annules,
    required this.urgentsOuverts,
    required this.coutTotalMaintenance,
  });

  factory DashboardMaintenance.fromJson(Map<String, dynamic> json) {
    return DashboardMaintenance(
      totalTickets: json['total_tickets'] ?? 0,
      enAttente: json['en_attente'] ?? 0,
      assignes: json['assignes'] ?? 0,
      enCours: json['en_cours'] ?? 0,
      termines: json['termines'] ?? 0,
      annules: json['annules'] ?? 0,
      urgentsOuverts: json['urgents_ouverts'] ?? 0,
      coutTotalMaintenance: _parseDouble(json['cout_total_maintenance']) ?? 0,
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

class DashboardBienRentable {
  final String codeBien;
  final String titre;
  final String typeBien;
  final double revenusTotaux;
  final double depensesMaintenance;
  final double beneficeNet;

  DashboardBienRentable({
    required this.codeBien,
    required this.titre,
    required this.typeBien,
    required this.revenusTotaux,
    required this.depensesMaintenance,
    required this.beneficeNet,
  });

  factory DashboardBienRentable.fromJson(Map<String, dynamic> json) {
    return DashboardBienRentable(
      codeBien: json['code_bien'] ?? '',
      titre: json['titre'] ?? '',
      typeBien: json['type_bien'] ?? '',
      revenusTotaux: _parseDouble(json['revenus_totaux']) ?? 0,
      depensesMaintenance: _parseDouble(json['depenses_maintenance']) ?? 0,
      beneficeNet: _parseDouble(json['benefice_net']) ?? 0,
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