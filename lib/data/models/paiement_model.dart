class PaiementModel {
  final int id;
  final int? contratId;
  final int? echeanceId;
  final String referencePaiement;
  final double montant;
  final String? datePaiement;
  final String? periodeConcernee;
  final String modePaiement;
  final String statut;
  final String? commentaire;

  // Champs joints
  final String? numeroContrat;
  final String? codeBien;
  final String? locataireNom;

  PaiementModel({
    required this.id,
    this.contratId,
    this.echeanceId,
    required this.referencePaiement,
    required this.montant,
    this.datePaiement,
    this.periodeConcernee,
    required this.modePaiement,
    required this.statut,
    this.commentaire,
    this.numeroContrat,
    this.codeBien,
    this.locataireNom,
  });

  factory PaiementModel.fromJson(Map<String, dynamic> json) {
    return PaiementModel(
      id: json['id'] ?? 0,
      contratId: json['contrat_id'],
      echeanceId: json['echeance_id'],
      referencePaiement: json['reference_paiement'] ?? '',
      montant: _parseDouble(json['montant']) ?? 0,
      datePaiement: json['date_paiement'],
      periodeConcernee: json['periode_concernee'],
      modePaiement: json['mode_paiement'] ?? '',
      statut: json['statut'] ?? '',
      commentaire: json['commentaire'],
      numeroContrat: json['numero_contrat'],
      codeBien: json['code_bien'],
      locataireNom: json['locataire_nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contrat_id': contratId,
      'echeance_id': echeanceId,
      'montant': montant,
      'mode_paiement': modePaiement,
      'date_paiement': datePaiement,
      'periode_concernee': periodeConcernee,
      'commentaire': commentaire,
    };
  }

  bool get isValide => statut == 'valide';
  bool get isEnAttente => statut == 'en_attente';
  bool get isAnnule => statut == 'annule';

  bool get isCash => modePaiement == 'cash';
  bool get isMobileMoney => modePaiement == 'mobile_money';
  bool get isBanque => modePaiement == 'banque';

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}