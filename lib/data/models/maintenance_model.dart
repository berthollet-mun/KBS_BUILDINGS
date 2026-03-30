class MaintenanceModel {
  final int id;
  final String numeroTicket;
  final int? bienId;
  final int? locataireId;
  final int? technicienId;
  final String titre;
  final String? description;
  final String? typePanne;
  final String priorite;
  final String statut;
  final String? dateSignalement;
  final String? dateAssignation;
  final String? dateDebut;
  final String? dateFin;
  final double? cout;
  final String? compteRendu;

  // Champs joints
  final String? codeBien;
  final String? titreBien;
  final String? locataireNom;
  final String? technicienNom;
  final String? technicienPrenom;

  MaintenanceModel({
    required this.id,
    required this.numeroTicket,
    this.bienId,
    this.locataireId,
    this.technicienId,
    required this.titre,
    this.description,
    this.typePanne,
    required this.priorite,
    required this.statut,
    this.dateSignalement,
    this.dateAssignation,
    this.dateDebut,
    this.dateFin,
    this.cout,
    this.compteRendu,
    this.codeBien,
    this.titreBien,
    this.locataireNom,
    this.technicienNom,
    this.technicienPrenom,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'] ?? 0,
      numeroTicket: json['numero_ticket'] ?? '',
      bienId: json['bien_id'],
      locataireId: json['locataire_id'],
      technicienId: json['technicien_id'],
      titre: json['titre'] ?? '',
      description: json['description'],
      typePanne: json['type_panne'],
      priorite: json['priorite'] ?? 'moyenne',
      statut: json['statut'] ?? '',
      dateSignalement: json['date_signalement'],
      dateAssignation: json['date_assignation'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      cout: _parseDouble(json['cout']),
      compteRendu: json['compte_rendu'],
      codeBien: json['code_bien'],
      titreBien: json['titre_bien'],
      locataireNom: json['locataire_nom'],
      technicienNom: json['technicien_nom'],
      technicienPrenom: json['technicien_prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bien_id': bienId,
      'locataire_id': locataireId,
      'technicien_id': technicienId,
      'titre': titre,
      'description': description,
      'type_panne': typePanne,
      'priorite': priorite,
      'statut': statut,
      'cout': cout,
      'compte_rendu': compteRendu,
    };
  }

  bool get isEnAttente => statut == 'en_attente';
  bool get isAssignee => statut == 'assignee';
  bool get isEnCours => statut == 'en_cours';
  bool get isTerminee => statut == 'terminee';
  bool get isAnnulee => statut == 'annulee';

  bool get isUrgente => priorite == 'urgente';
  bool get isHaute => priorite == 'haute';
  bool get isMoyenne => priorite == 'moyenne';
  bool get isFaible => priorite == 'faible';

  String get technicienNomComplet {
    if (technicienNom == null) return 'Non assigné';
    return '${technicienPrenom ?? ''} $technicienNom'.trim();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}