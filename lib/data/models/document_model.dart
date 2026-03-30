class DocumentModel {
  final int id;
  final String typeDocument;
  final String cheminFichier;
  final String? nomFichier;
  final int? tailleFichier;
  final String? mimeType;
  final String? entiteType;
  final int? entiteId;
  final String? createdAt;

  DocumentModel({
    required this.id,
    required this.typeDocument,
    required this.cheminFichier,
    this.nomFichier,
    this.tailleFichier,
    this.mimeType,
    this.entiteType,
    this.entiteId,
    this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      typeDocument: json['type_document'] ?? '',
      cheminFichier: json['chemin_fichier'] ?? '',
      nomFichier: json['nom_fichier'],
      tailleFichier: json['taille_fichier'],
      mimeType: json['mime_type'],
      entiteType: json['entite_type'],
      entiteId: json['entite_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type_document': typeDocument,
      'entite_type': entiteType,
      'entite_id': entiteId,
    };
  }

  bool get isPdf => mimeType == 'application/pdf';
  bool get isImage => mimeType?.startsWith('image/') ?? false;

  String get tailleFormatee {
    if (tailleFichier == null) return '';
    if (tailleFichier! < 1024) return '${tailleFichier} B';
    if (tailleFichier! < 1024 * 1024) {
      return '${(tailleFichier! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(tailleFichier! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}