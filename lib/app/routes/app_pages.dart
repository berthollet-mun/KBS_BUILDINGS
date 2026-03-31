// lib/app/routes/app_pages.dart

import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_routes.dart';

// --- Views ---
import '../../views/public/splash/splash_page.dart';
import '../../views/public/welcome/welcome_page.dart';
import '../../views/auth/login/login_page.dart';
import '../../views/auth/register/register_page.dart';
import '../../views/dashboard/dashboard_page.dart';
import '../../views/biens/biens_list_page.dart';
import '../../views/biens/biens_disponibles_page.dart';
import '../../views/biens/bien_detail_page.dart';
import '../../views/biens/bien_form_page.dart';
import '../../views/proprietaires/proprietaires_list_page.dart';
import '../../views/proprietaires/proprietaire_detail_page.dart';
import '../../views/proprietaires/proprietaire_form_page.dart';
import '../../views/locataires/locataires_list_page.dart';
import '../../views/locataires/locataire_detail_page.dart';
import '../../views/locataires/locataire_form_page.dart';
import '../../views/contrats/contrats_list_page.dart';
import '../../views/contrats/contrat_detail_page.dart';
import '../../views/contrats/contrat_form_page.dart';
import '../../views/paiements/paiements_list_page.dart';
import '../../views/paiements/paiement_detail_page.dart';
import '../../views/paiements/paiement_form_page.dart';
import '../../views/echeances/echeances_list_page.dart';
import '../../views/echeances/echeances_en_retard_page.dart';
import '../../views/echeances/echeances_a_venir_page.dart';
import '../../views/maintenances/maintenances_list_page.dart';
import '../../views/maintenances/maintenance_detail_page.dart';
import '../../views/maintenances/maintenance_form_page.dart';
import '../../views/visites/visites_list_page.dart';
import '../../views/visites/visite_form_page.dart';
import '../../views/users/users_list_page.dart';
import '../../views/users/user_detail_page.dart';
import '../../views/users/user_form_page.dart';
import '../../views/qrcodes/qr_scan_page.dart';
import '../../views/qrcodes/qr_result_page.dart';
import '../../views/profile/profile_page.dart';
import '../../views/profile/change_password_page.dart';
import '../../views/notifications/notifications_page.dart';
import '../../views/documents/documents_page.dart';
import '../../views/documents/document_upload_page.dart';
import '../../views/configurations/configurations_page.dart';
import '../../views/roles/roles_page.dart';

class AppPages {
  static final List<GetPage> pages = [
    // ==================== PUBLIC ====================
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
    ),

    // ==================== AUTH ====================
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),

    // ==================== DASHBOARD ====================
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
    ),

    // ==================== BIENS ====================
    GetPage(
      name: AppRoutes.biensList,
      page: () => const BiensListPage(),
    ),
    GetPage(
      name: AppRoutes.biensDisponibles,
      page: () => const BiensDisponiblesPage(),
    ),
    GetPage(
      name: AppRoutes.bienDetail,
      page: () => const BienDetailPage(),
    ),
    GetPage(
      name: AppRoutes.bienCreate,
      page: () => const BienFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.bienEdit,
      page: () => const BienFormPage(isEditing: true),
    ),

    // ==================== PROPRIÉTAIRES ====================
    GetPage(
      name: AppRoutes.proprietairesList,
      page: () => const ProprietairesListPage(),
    ),
    GetPage(
      name: AppRoutes.proprietaireDetail,
      page: () => const ProprietaireDetailPage(),
    ),
    GetPage(
      name: AppRoutes.proprietaireCreate,
      page: () => const ProprietaireFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.proprietaireEdit,
      page: () => const ProprietaireFormPage(isEditing: true),
    ),

    // ==================== LOCATAIRES ====================
    GetPage(
      name: AppRoutes.locatairesList,
      page: () => const LocatairesListPage(),
    ),
    GetPage(
      name: AppRoutes.locataireDetail,
      page: () => const LocataireDetailPage(),
    ),
    GetPage(
      name: AppRoutes.locataireCreate,
      page: () => const LocataireFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.locataireEdit,
      page: () => const LocataireFormPage(isEditing: true),
    ),

    // ==================== CONTRATS ====================
    GetPage(
      name: AppRoutes.contratsList,
      page: () => const ContratsListPage(),
    ),
    GetPage(
      name: AppRoutes.contratDetail,
      page: () => const ContratDetailPage(),
    ),
    GetPage(
      name: AppRoutes.contratCreate,
      page: () => const ContratFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.contratEdit,
      page: () => const ContratFormPage(isEditing: true),
    ),

    // ==================== PAIEMENTS ====================
    GetPage(
      name: AppRoutes.paiementsList,
      page: () => const PaiementsListPage(),
    ),
    GetPage(
      name: AppRoutes.paiementDetail,
      page: () => const PaiementDetailPage(),
    ),
    GetPage(
      name: AppRoutes.paiementCreate,
      page: () => const PaiementFormPage(),
    ),

    // ==================== ÉCHÉANCES ====================
    GetPage(
      name: AppRoutes.echeancesList,
      page: () => const EcheancesListPage(),
    ),
    GetPage(
      name: AppRoutes.echeancesEnRetard,
      page: () => const EcheancesEnRetardPage(),
    ),
    GetPage(
      name: AppRoutes.echeancesAVenir,
      page: () => const EcheancesAVenirPage(),
    ),

    // ==================== MAINTENANCE ====================
    GetPage(
      name: AppRoutes.maintenancesList,
      page: () => const MaintenancesListPage(),
    ),
    GetPage(
      name: AppRoutes.maintenanceDetail,
      page: () => const MaintenanceDetailPage(),
    ),
    GetPage(
      name: AppRoutes.maintenanceCreate,
      page: () => const MaintenanceFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.maintenanceEdit,
      page: () => const MaintenanceFormPage(isEditing: true),
    ),

    // ==================== VISITES ====================
    GetPage(
      name: AppRoutes.visitesList,
      page: () => const VisitesListPage(),
    ),
    GetPage(
      name: AppRoutes.visiteReserver,
      page: () => const VisiteFormPage(),
    ),

    // ==================== UTILISATEURS ====================
    GetPage(
      name: AppRoutes.usersList,
      page: () => const UsersListPage(),
    ),
    GetPage(
      name: AppRoutes.userDetail,
      page: () => const UserDetailPage(),
    ),
    GetPage(
      name: AppRoutes.userCreate,
      page: () => const UserFormPage(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.userEdit,
      page: () => const UserFormPage(isEditing: true),
    ),

    // ==================== QR CODES ====================
    GetPage(
      name: AppRoutes.qrCodeScan,
      page: () => const QrScanPage(),
    ),
    GetPage(
      name: AppRoutes.qrCodeResult,
      page: () => const QrResultPage(),
    ),

    // ==================== PROFIL ====================
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
    ),

    // ==================== NOTIFICATIONS ====================
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),

    // ==================== DOCUMENTS ====================
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentsPage(),
    ),
    GetPage(
      name: AppRoutes.documentUpload,
      page: () => const DocumentUploadPage(),
    ),

    // ==================== CONFIGURATIONS ====================
    GetPage(
      name: AppRoutes.configurations,
      page: () => const ConfigurationsPage(),
    ),

    // ==================== RÔLES ====================
    GetPage(
      name: AppRoutes.roles,
      page: () => const RolesPage(),
    ),
  ];

  //  ==================== DASHBOARD ====================
  GetPage(
  name: AppRoutes.dashboard,
  page: () => const MainScaffold(),  // ← C'est le shell avec bottom nav
),
}