// lib/app/routes/app_routes.dart

class AppRoutes {
  // --- Public ---
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';

  // --- Dashboard ---
  static const String dashboard = '/dashboard';

  // --- Biens ---
  static const String biensList = '/biens';
  static const String biensDisponibles = '/biens-disponibles';
  static const String bienDetail = '/bien-detail';
  static const String bienCreate = '/bien-create';
  static const String bienEdit = '/bien-edit';

  // --- Propriétaires ---
  static const String proprietairesList = '/proprietaires';
  static const String proprietaireDetail = '/proprietaire-detail';
  static const String proprietaireCreate = '/proprietaire-create';
  static const String proprietaireEdit = '/proprietaire-edit';

  // --- Locataires ---
  static const String locatairesList = '/locataires';
  static const String locataireDetail = '/locataire-detail';
  static const String locataireCreate = '/locataire-create';
  static const String locataireEdit = '/locataire-edit';

  // --- Contrats ---
  static const String contratsList = '/contrats';
  static const String contratDetail = '/contrat-detail';
  static const String contratCreate = '/contrat-create';
  static const String contratEdit = '/contrat-edit';

  // --- Paiements ---
  static const String paiementsList = '/paiements';
  static const String paiementDetail = '/paiement-detail';
  static const String paiementCreate = '/paiement-create';

  // --- Échéances ---
  static const String echeancesList = '/echeances';
  static const String echeancesEnRetard = '/echeances-en-retard';
  static const String echeancesAVenir = '/echeances-a-venir';

  // --- Maintenance ---
  static const String maintenancesList = '/maintenances';
  static const String maintenanceDetail = '/maintenance-detail';
  static const String maintenanceCreate = '/maintenance-create';
  static const String maintenanceEdit = '/maintenance-edit';

  // --- Visites ---
  static const String visitesList = '/visites';
  static const String visiteReserver = '/visite-reserver';

  // --- Utilisateurs ---
  static const String usersList = '/users';
  static const String userDetail = '/user-detail';
  static const String userCreate = '/user-create';
  static const String userEdit = '/user-edit';

  // --- QR Codes ---
  static const String qrCodeScan = '/qr-scan';
  static const String qrCodeResult = '/qr-result';

  // --- Profil ---
  static const String profile = '/profile';
  static const String changePassword = '/change-password';

  // --- Notifications ---
  static const String notifications = '/notifications';

  // --- Documents ---
  static const String documents = '/documents';
  static const String documentUpload = '/document-upload';

  // --- Configuration ---
  static const String configurations = '/configurations';

  // --- Rôles ---
  static const String roles = '/roles';
}