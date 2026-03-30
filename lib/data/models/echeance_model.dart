class EcheanceModel {
  final int id;
  final String dateEcheance;
  final double montantAttendu;
  final double montantPaye;
  final String statut;
  final int joursRetard;

  // Champs additionnels (vue en_retard / a_venir)
  final double? resteAPayer;
  final String? numeroContrat;
  final String? codeBien;
  final String? titreBien;
  final String? nomLocataire;
  final String? telLocataire;
  final String? emailLocataire;
  final int? contratId;

  EcheanceModel({
    required this.id,
    required this.dateEcheance,
    required this.montantAttendu,
    required this.montantPaye,
    required this.statut,
    required this.joursRetard,
    this.resteAPayer,
    this.numeroContrat,
    this.codeBien,
    this.titreBien,
    this.nomLocataire,
    this.telLocataire,
    this.emailLocataire,
    this.contratId,
  });

  factory EcheanceModel.fromJson(Map<String, dynamic> json) {
    return EcheanceModel(
      id: json['id'] ?? json['echeance_id'] ?? 0,
      dateEcheance: json['date_echeance'] ?? '',
      montantAttendu: _parseDouble(json['montant_attendu']) ?? 0,
      montantPaye: _parseDouble(json['montant_paye']) ?? 0,
      statut: json['statut'] ?? '',
      joursRetard: json['jours_retard'] ?? 0,
      resteAPayer: _parseDouble(json['reste_a_payer']),
      numeroContrat: json['numero_contrat'],
      codeBien: json['code_bien'],
      titreBien: json['titre_bien'],
      nomLocataire: json['nom_locataire'],
      telLocataire: json['tel_locataire'],
      emailLocataire: json['email_locataire'],
      contratId: json['contrat_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_echeance': dateEcheance,
      'montant_attendu': montantAttendu,
      'montant_paye': montantPaye,
      'statut': statut,
      'jours_retard': joursRetard,
    };
  }

  bool get isPayee => statut == 'payee';
  bool get isEnRetard => statut == 'en_retard';
  bool get isAVenir => statut == 'a_venir';
  bool get isPartielle => statut == 'partielle';

  double get resteCalcule => montantAttendu - montantPaye;

  double get progressionPourcent {
    if (montantAttendu == 0) return 0;
    return (montantPaye / montantAttendu) * 100;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}