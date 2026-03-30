import 'echeance_model.dart';
import 'paiement_model.dart';

class ContratModel {
  final int id;
  final String numeroContrat;
  final int? bienId;
  final int? locataireId;
  final String dateDebut;
  final String dateFin;
  final double montantLoyer;
  final double? caution;
  final String? periodicite;
  final String statut;

  // Champs joints
  final String? codeBien;
  final String? titreBien;
  final String? adresseBien;
  final String? typeBien;
  final String? locataireNom;
  final String? locataireTel;
  final String? locataireEmail;
  final String? proprietaireNom;

  // Détail
  final int? nbEcheancesGenerees;
  final List<EcheanceModel>? echeances;
  final List<PaiementModel>? paiements;

  ContratModel({
    required this.id,
    required this.numeroContrat,
    this.bienId,
    this.locataireId,
    required this.dateDebut,
    required this.dateFin,
    required this.montantLoyer,
    this.caution,
    this.periodicite,
    required this.statut,
    this.codeBien,
    this.titreBien,
    this.adresseBien,
    this.typeBien,
    this.locataireNom,
    this.locataireTel,
    this.locataireEmail,
    this.proprietaireNom,
    this.nbEcheancesGenerees,
    this.echeances,
    this.paiements,
  });

  factory ContratModel.fromJson(Map<String, dynamic> json) {
    return ContratModel(
      id: json['id'] ?? 0,
      numeroContrat: json['numero_contrat'] ?? '',
      bienId: json['bien_id'],
      locataireId: json['locataire_id'],
      dateDebut: json['date_debut'] ?? '',
      dateFin: json['date_fin'] ?? '',
      montantLoyer: _parseDouble(json['montant_loyer']) ?? 0,
      caution: _parseDouble(json['caution']),
      periodicite: json['periodicite'],
      statut: json['statut'] ?? '',
      codeBien: json['code_bien'],
      titreBien: json['titre_bien'],
      adresseBien: json['adresse_bien'],
      typeBien: json['type_bien'],
      locataireNom: json['locataire_nom'],
      locataireTel: json['locataire_tel'],
      locataireEmail: json['locataire_email'],
      proprietaireNom: json['proprietaire_nom'],
      nbEcheancesGenerees: json['nb_echeances_generees'],
      echeances: json['echeances'] != null
          ? (json['echeances'] as List)
              .map((e) => EcheanceModel.fromJson(e))
              .toList()
          : null,
      paiements: json['paiements'] != null
          ? (json['paiements'] as List)
              .map((e) => PaiementModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bien_id': bienId,
      'locataire_id': locataireId,
      'date_debut': dateDebut,
      'date_fin': dateFin,
      'montant_loyer': montantLoyer,
      'caution': caution,
      'periodicite': periodicite,
    };
  }

  bool get isActif => statut == 'actif';
  bool get isExpire => statut == 'expire';
  bool get isResilie => statut == 'resilie';

  int get nombreEcheances => echeances?.length ?? 0;

  int get echeancesPayees {
    return echeances?.where((e) => e.statut == 'payee').length ?? 0;
  }

  int get echeancesEnRetard {
    return echeances?.where((e) => e.statut == 'en_retard').length ?? 0;
  }

  double get totalPaye {
    return paiements
            ?.where((p) => p.statut == 'valide')
            .fold<double>(0, (sum, p) => sum + p.montant) ??
        0;
  }

  double get progressionPourcent {
    if (nombreEcheances == 0) return 0;
    return (echeancesPayees / nombreEcheances) * 100;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}