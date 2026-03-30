class QrCodeModel {
  final int id;
  final int bienId;
  final String codeQr;
  final String? imageQr;
  final String? dateGeneration;
  final int? actif;

  // Champs additionnels du scan
  final String? codeBien;
  final String? titre;
  final String? typeBien;
  final String? statut;
  final String? adresse;
  final String? commune;
  final double? prixLoyer;
  final double? prixVente;
  final double? latitude;
  final double? longitude;
  final String? proprietaireNom;

  QrCodeModel({
    required this.id,
    required this.bienId,
    required this.codeQr,
    this.imageQr,
    this.dateGeneration,
    this.actif,
    this.codeBien,
    this.titre,
    this.typeBien,
    this.statut,
    this.adresse,
    this.commune,
    this.prixLoyer,
    this.prixVente,
    this.latitude,
    this.longitude,
    this.proprietaireNom,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
      id: json['id'] ?? 0,
      bienId: json['bien_id'] ?? 0,
      codeQr: json['code_qr'] ?? '',
      imageQr: json['image_qr'],
      dateGeneration: json['date_generation'],
      actif: json['actif'],
      codeBien: json['code_bien'],
      titre: json['titre'],
      typeBien: json['type_bien'],
      statut: json['statut'],
      adresse: json['adresse'],
      commune: json['commune'],
      prixLoyer: _parseDouble(json['prix_loyer']),
      prixVente: _parseDouble(json['prix_vente']),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      proprietaireNom: json['proprietaire_nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bien_id': bienId,
      'code_qr': codeQr,
      'image_qr': imageQr,
      'date_generation': dateGeneration,
      'actif': actif,
    };
  }

  bool get isActif => actif == 1;

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}