import 'photo_bien_model.dart';
import 'qrcode_model.dart';
import 'contrat_model.dart';

class BienModel {
  final int id;
  final String codeBien;
  final String titre;
  final String typeBien;
  final String? description;
  final String? adresse;
  final String? commune;
  final String? quartier;
  final String? ville;
  final double? surface;
  final int? nbPieces;
  final int? etage;
  final int? meuble;
  final int? anneeConstruction;
  final String? referenceCadastrale;
  final double? prixLoyer;
  final double? prixVente;
  final String statut;
  final double? latitude;
  final double? longitude;
  final int? proprietaireId;
  final String? proprietaireNom;
  final String? proprietaireTel;
  final int? createdBy;
  final String? createurNom;
  final String? createurPrenom;
  final String? createdAt;
  final String? photoPrincipale;
  final List<PhotoBienModel>? photos;
  final QrCodeModel? qrCode;
  final ContratModel? contratActif;

  BienModel({
    required this.id,
    required this.codeBien,
    required this.titre,
    required this.typeBien,
    this.description,
    this.adresse,
    this.commune,
    this.quartier,
    this.ville,
    this.surface,
    this.nbPieces,
    this.etage,
    this.meuble,
    this.anneeConstruction,
    this.referenceCadastrale,
    this.prixLoyer,
    this.prixVente,
    required this.statut,
    this.latitude,
    this.longitude,
    this.proprietaireId,
    this.proprietaireNom,
    this.proprietaireTel,
    this.createdBy,
    this.createurNom,
    this.createurPrenom,
    this.createdAt,
    this.photoPrincipale,
    this.photos,
    this.qrCode,
    this.contratActif,
  });

  factory BienModel.fromJson(Map<String, dynamic> json) {
    return BienModel(
      id: json['id'] ?? 0,
      codeBien: json['code_bien'] ?? '',
      titre: json['titre'] ?? '',
      typeBien: json['type_bien'] ?? '',
      description: json['description'],
      adresse: json['adresse'],
      commune: json['commune'],
      quartier: json['quartier'],
      ville: json['ville'],
      surface: _parseDouble(json['surface']),
      nbPieces: json['nb_pieces'],
      etage: json['etage'],
      meuble: json['meuble'],
      anneeConstruction: json['annee_construction'],
      referenceCadastrale: json['reference_cadastrale'],
      prixLoyer: _parseDouble(json['prix_loyer']),
      prixVente: _parseDouble(json['prix_vente']),
      statut: json['statut'] ?? 'disponible',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      proprietaireId: json['proprietaire_id'],
      proprietaireNom: json['proprietaire_nom'],
      proprietaireTel: json['proprietaire_tel'],
      createdBy: json['created_by'],
      createurNom: json['createur_nom'],
      createurPrenom: json['createur_prenom'],
      createdAt: json['created_at'],
      photoPrincipale: json['photo_principale'],
      photos: json['photos'] != null
          ? (json['photos'] as List)
              .map((e) => PhotoBienModel.fromJson(e))
              .toList()
          : null,
      qrCode: json['qr_code'] != null
          ? QrCodeModel.fromJson(json['qr_code'])
          : null,
      contratActif: json['contrat_actif'] != null
          ? ContratModel.fromJson(json['contrat_actif'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'type_bien': typeBien,
      'description': description,
      'adresse': adresse,
      'commune': commune,
      'quartier': quartier,
      'ville': ville,
      'surface': surface,
      'nb_pieces': nbPieces,
      'etage': etage,
      'meuble': meuble,
      'prix_loyer': prixLoyer,
      'prix_vente': prixVente,
      'statut': statut,
      'latitude': latitude,
      'longitude': longitude,
      'proprietaire_id': proprietaireId,
    };
  }

  bool get isDisponible => statut == 'disponible';
  bool get isOccupe => statut == 'occupe';
  bool get isMaintenance => statut == 'maintenance';
  bool get isVendu => statut == 'vendu';
  bool get isMeuble => meuble == 1;
  bool get hasPhotos => photos != null && photos!.isNotEmpty;
  bool get hasQrCode => qrCode != null;
  bool get hasContratActif => contratActif != null;
  bool get hasCoordinates => latitude != null && longitude != null;

  String get adresseComplete {
    final parts = [adresse, quartier, commune, ville]
        .where((e) => e != null && e.isNotEmpty);
    return parts.join(', ');
  }

  String get prixLoyerFormate {
    if (prixLoyer == null) return 'N/A';
    return '${prixLoyer!.toStringAsFixed(prixLoyer! == prixLoyer!.roundToDouble() ? 0 : 2)} USD/mois';
  }

  String get prixVenteFormate {
    if (prixVente == null) return 'N/A';
    return '${prixVente!.toStringAsFixed(prixVente! == prixVente!.roundToDouble() ? 0 : 2)} USD';
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}