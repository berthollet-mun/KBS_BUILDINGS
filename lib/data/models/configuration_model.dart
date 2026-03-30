class ConfigurationModel {
  final int id;
  final String cle;
  final String valeur;
  final String? typeValeur;
  final String? description;
  final int? modifiable;

  ConfigurationModel({
    required this.id,
    required this.cle,
    required this.valeur,
    this.typeValeur,
    this.description,
    this.modifiable,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationModel(
      id: json['id'] ?? 0,
      cle: json['cle'] ?? '',
      valeur: json['valeur'] ?? '',
      typeValeur: json['type_valeur'],
      description: json['description'],
      modifiable: json['modifiable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valeur': valeur,
    };
  }

  bool get isModifiable => modifiable == 1;
}