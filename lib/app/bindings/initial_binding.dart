// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';
import 'package:kbs/core/services/notification_service.dart';
import 'package:kbs/core/services/qrcode_service.dart';

// --- Services ---
import '../../core/services/auth_service.dart';
import '../../core/services/bien_service.dart';
import '../../core/services/proprietaire_service.dart';
import '../../core/services/locataire_service.dart';
import '../../core/services/contrat_service.dart';
import '../../core/services/paiement_service.dart';
import '../../core/services/echeance_service.dart';
import '../../core/services/maintenance_service.dart';
import '../../core/services/visite_service.dart';
import '../../core/services/user_service.dart';
import '../../core/services/role_service.dart';
import '../../core/services/document_service.dart';
import '../../core/services/configuration_service.dart';
import '../../core/services/dashboard_service.dart';

// --- Controllers ---
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/bien_controller.dart';
import 'package:kbs/controllers/configuration_controller.dart';
import 'package:kbs/controllers/contrat_controller.dart';
import 'package:kbs/controllers/dashboard_controller.dart';
import 'package:kbs/controllers/document_controller.dart';
import 'package:kbs/controllers/echeance_controller.dart';
import 'package:kbs/controllers/locataire_controller.dart';
import 'package:kbs/controllers/maintenance_controller.dart';
import 'package:kbs/controllers/notification_controller.dart';
import 'package:kbs/controllers/paiement_controller.dart';
import 'package:kbs/controllers/proprietaire_controller.dart';
import 'package:kbs/controllers/qrcode_controller.dart';
import 'package:kbs/controllers/role_controller.dart';
import 'package:kbs/controllers/theme_controller.dart';
import 'package:kbs/controllers/user_controller.dart';
import 'package:kbs/controllers/visite_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== SERVICES (permanent) ====================

    // Core services (déjà initialisés dans AppInitialization)
    // StorageService et ApiService sont mis via Get.put dans initialization.dart

    // Business services
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => BienService(), fenix: true);
    Get.lazyPut(() => ProprietaireService(), fenix: true);
    Get.lazyPut(() => LocataireService(), fenix: true);
    Get.lazyPut(() => ContratService(), fenix: true);
    Get.lazyPut(() => PaiementService(), fenix: true);
    Get.lazyPut(() => EcheanceService(), fenix: true);
    Get.lazyPut(() => MaintenanceService(), fenix: true);
    Get.lazyPut(() => VisiteService(), fenix: true);
    Get.lazyPut(() => NotificationAppService(), fenix: true);
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => RoleService(), fenix: true);
    Get.lazyPut(() => QrCodeService(), fenix: true);
    Get.lazyPut(() => DocumentService(), fenix: true);
    Get.lazyPut(() => ConfigurationService(), fenix: true);
    Get.lazyPut(() => DashboardService(), fenix: true);

    // ==================== CONTROLLERS ====================

    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => BienController(), fenix: true);
    Get.lazyPut(() => ProprietaireController(), fenix: true);
    Get.lazyPut(() => LocataireController(), fenix: true);
    Get.lazyPut(() => ContratController(), fenix: true);
    Get.lazyPut(() => PaiementController(), fenix: true);
    Get.lazyPut(() => EcheanceController(), fenix: true);
    Get.lazyPut(() => MaintenanceController(), fenix: true);
    Get.lazyPut(() => VisiteController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => RoleController(), fenix: true);
    Get.lazyPut(() => QrCodeController(), fenix: true);
    Get.lazyPut(() => DocumentController(), fenix: true);
    Get.lazyPut(() => ConfigurationController(), fenix: true);
  }
}