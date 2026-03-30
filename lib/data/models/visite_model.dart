class VisiteModel {
  final int id;
  final int? bienId;
  final int? agentId;
  final String? clientNom;
  final String? clientTelephone;
  final String? clientEmail;
  final String? dateVisite;
  final String statut;
  final String? observation;
  final int? noteSatisfaction;
  final String? createdAt;

  // Champs joints
  final String? codeBien;
  final String? titreBien;

  VisiteModel({
    required this.id,
    this.bienId,
    this.agentId,
    this.clientNom,
    this.clientTelephone,
    this.clientEmail,
    this.dateVisite,
    required this.statut,
    this.observation,
    this.noteSatisfaction,
    this.createdAt,
    this.codeBien,
    this.titreBien,
  });

  factory VisiteModel.fromJson(Map<String, dynamic> json) {
    return VisiteModel(
      id: json['id'] ?? 0,
      bienId: json['bien_id'],
      agentId: json['agent_id'],
      clientNom: json['client_nom'],
      clientTelephone: json['client_telephone'],
      clientEmail: json['client_email'],
      dateVisite: json['date_visite'],
      statut: json['statut'] ?? '',
      observation: json['observation'],
      noteSatisfaction: json['note_satisfaction'],
      createdAt: json['created_at'],
      codeBien: json['code_bien'],
      titreBien: json['titre_bien'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bien_id': bienId,
      'client_nom': clientNom,
      'client_telephone': clientTelephone,
      'client_email': clientEmail,
      'date_visite': dateVisite,
      'observation': observation,
    };
  }

  bool get isPlanifiee => statut == 'planifiee';
  bool get isEffectuee => statut == 'effectuee';
  bool get isAnnulee => statut == 'annulee';
  bool get isReportee => statut == 'reportee';
}