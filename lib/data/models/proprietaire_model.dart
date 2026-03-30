import 'bien_model.dart';

class ProprietaireModel {
  final int id;
  final String nomComplet;
  final String? telephone;
  final String? email;
  final String? adresse;
  final String? pieceIdentite;
  final String? photo;
  final int? utilisateurId;
  final String? createdAt;
  final List<BienModel>? biens;

  ProprietaireModel({
    required this.id,
    required this.nomComplet,
    this.telephone,
    this.email,
    this.adresse,
    this.pieceIdentite,
    this.photo,
    this.utilisateurId,
    this.createdAt,
    this.biens,
  });

  factory ProprietaireModel.fromJson(Map<String, dynamic> json) {
    return ProprietaireModel(
      id: json['id'] ?? 0,
      nomComplet: json['nom_complet'] ?? '',
      telephone: json['telephone'],
      email: json['email'],
      adresse: json['adresse'],
      pieceIdentite: json['piece_identite'],
      photo: json['photo'],
      utilisateurId: json['utilisateur_id'],
      createdAt: json['created_at'],
      biens: json['biens'] != null
          ? (json['biens'] as List)
              .map((e) => BienModel.fromJson(e))
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

  int get nombreBiens => biens?.length ?? 0;
}