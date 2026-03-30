class PhotoBienModel {
  final int id;
  final String cheminFichier;
  final String? legende;
  final int principale;
  final int ordre;

  PhotoBienModel({
    required this.id,
    required this.cheminFichier,
    this.legende,
    required this.principale,
    required this.ordre,
  });

  factory PhotoBienModel.fromJson(Map<String, dynamic> json) {
    return PhotoBienModel(
      id: json['id'] ?? 0,
      cheminFichier: json['chemin_fichier'] ?? '',
      legende: json['legende'],
      principale: json['principale'] ?? 0,
      ordre: json['ordre'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chemin_fichier': cheminFichier,
      'legende': legende,
      'principale': principale,
      'ordre': ordre,
    };
  }

  bool get isPrincipale => principale == 1;
}