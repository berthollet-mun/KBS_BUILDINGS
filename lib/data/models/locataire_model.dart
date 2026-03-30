import 'contrat_model.dart';

class LocataireModel {
  final int id;
  final String nomComplet;
  final String? telephone;
  final String? email;
  final String? adresse;
  final String? pieceIdentite;
  final String? photo;
  final int? utilisateurId;
  final String? createdAt;
  final List<ContratModel>? contrats;

  LocataireModel({
    required this.id,
    required this.nomComplet,
    this.telephone,
    this.email,
    this.adresse,
    this.pieceIdentite,
    this.photo,
    this.utilisateurId,
    this.createdAt,
    this.contrats,
  });

  factory LocataireModel.fromJson(Map<String, dynamic> json) {
    return LocataireModel(
      id: json['id'] ?? 0,
      nomComplet: json['nom_complet'] ?? '',
      telephone: json['telephone'],
      email: json['email'],
      adresse: json['adresse'],
      pieceIdentite: json['piece_identite'],
      photo: json['photo'],
      utilisateurId: json['utilisateur_id'],
      createdAt: json['created_at'],
      contrats: json['contrats'] != null
          ? (json['contrats'] as List)
              .map((e) => ContratModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom_complet': nomComplet,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'piece_identite': pieceIdentite,
    };
  }

  int get nombreContrats => contrats?.length ?? 0;

  bool get hasContratActif {
    return contrats?.any((c) => c.statut == 'actif') ?? false;
  }

  ContratModel? get contratActif {
    try {
      return contrats?.firstWhere((c) => c.statut == 'actif');
    } catch (_) {
      return null;
    }
  }
}