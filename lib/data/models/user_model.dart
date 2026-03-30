class UserModel {
  final int id;
  final String nom;
  final String? postnom;
  final String? prenom;
  final String email;
  final String? telephone;
  final String statut;
  final int? roleId;
  final String? roleNom;
  final String? roleDescription;
  final String? avatar;
  final String? derniereConnexion;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.nom,
    this.postnom,
    this.prenom,
    required this.email,
    this.telephone,
    required this.statut,
    this.roleId,
    this.roleNom,
    this.roleDescription,
    this.avatar,
    this.derniereConnexion,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      postnom: json['postnom'],
      prenom: json['prenom'],
      email: json['email'] ?? '',
      telephone: json['telephone'],
      statut: json['statut'] ?? 'actif',
      roleId: json['role_id'],
      roleNom: json['role_nom'],
      roleDescription: json['role_description'],
      avatar: json['avatar'],
      derniereConnexion: json['derniere_connexion'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'statut': statut,
      'role_id': roleId,
      'role_nom': roleNom,
      'role_description': roleDescription,
      'avatar': avatar,
      'derniere_connexion': derniereConnexion,
      'created_at': createdAt,
    };
  }

  String get nomComplet {
    final parts = [nom, postnom, prenom].where((e) => e != null && e.isNotEmpty);
    return parts.join(' ');
  }

  bool get isAdmin => roleNom == 'admin';
  bool get isAgent => roleNom == 'agent';
  bool get isProprietaire => roleNom == 'proprietaire';
  bool get isLocataire => roleNom == 'locataire';
  bool get isTechnicien => roleNom == 'technicien';
  bool get isClient => roleNom == 'client';
  bool get isActif => statut == 'actif';

  UserModel copyWith({
    String? nom,
    String? postnom,
    String? prenom,
    String? telephone,
    String? avatar,
    String? statut,
    int? roleId,
  }) {
    return UserModel(
      id: id,
      nom: nom ?? this.nom,
      postnom: postnom ?? this.postnom,
      prenom: prenom ?? this.prenom,
      email: email,
      telephone: telephone ?? this.telephone,
      statut: statut ?? this.statut,
      roleId: roleId ?? this.roleId,
      roleNom: roleNom,
      roleDescription: roleDescription,
      avatar: avatar ?? this.avatar,
      derniereConnexion: derniereConnexion,
      createdAt: createdAt,
    );
  }
}