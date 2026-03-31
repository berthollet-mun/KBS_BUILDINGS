// lib/app/initialization.dart

// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:kbs/controllers/auth_controller.dart';
import 'package:kbs/controllers/theme_controller.dart';
import 'package:kbs/core/services/notification_service.dart';
import 'package:kbs/core/services/qrcode_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/api_service.dart';
import '../core/services/auth_service.dart';
import '../core/services/bien_service.dart';
import '../core/services/proprietaire_service.dart';
import '../core/services/locataire_service.dart';
import '../core/services/contrat_service.dart';
import '../core/services/paiement_service.dart';
import '../core/services/echeance_service.dart';
import '../core/services/maintenance_service.dart';
import '../core/services/visite_service.dart';
import '../core/services/user_service.dart';
import '../core/services/role_service.dart';
import '../core/services/document_service.dart';
import '../core/services/configuration_service.dart';
import '../core/services/dashboard_service.dart';


class AppInitialization {
  static Future<void> initialize() async {
    print('🚀 Démarrage de l\'initialisation IMMO API...');

    try {
      // Étape 1: Services de base
      await _initializeCoreServices();

      // Étape 2: Services métier
      _initializeBusinessServices();

      // Étape 3: Controllers essentiels
      _initializeEssentialControllers();

      print('🎉 Initialisation terminée avec succès !');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  static Future<void> _initializeCoreServices() async {
    print('🔧 Initialisation des services de base...');

    // 1. StorageService (PREMIER - obligatoire)
    final storageService = StorageService();
    await Get.putAsync<StorageService>(() async {
      return await storageService.init();
    }, permanent: true);
    print('   ✅ StorageService initialisé');

    // 2. ApiService (dépend de StorageService pour le token)
    Get.put(ApiService(), permanent: true);
    print('   ✅ ApiService initialisé');
  }

  static void _initializeBusinessServices() {
    print('🔧 Initialisation des services métier...');

    Get.put(AuthService(), permanent: true);
    print('   ✅ AuthService');

    Get.put(DashboardService(), permanent: true);
    print('   ✅ DashboardService');

    Get.put(BienService(), permanent: true);
    print('   ✅ BienService');

    Get.put(ProprietaireService(), permanent: true);
    print('   ✅ ProprietaireService');

    Get.put(LocataireService(), permanent: true);
    print('   ✅ LocataireService');

    Get.put(ContratService(), permanent: true);
    print('   ✅ ContratService');

    Get.put(PaiementService(), permanent: true);
    print('   ✅ PaiementService');

    Get.put(EcheanceService(), permanent: true);
    print('   ✅ EcheanceService');

    Get.put(MaintenanceService(), permanent: true);
    print('   ✅ MaintenanceService');

    Get.put(VisiteService(), permanent: true);
    print('   ✅ VisiteService');

    Get.put(NotificationAppService(), permanent: true);
    print('   ✅ NotificationAppService');

    Get.put(UserService(), permanent: true);
    print('   ✅ UserService');

    Get.put(RoleService(), permanent: true);
    print('   ✅ RoleService');

    Get.put(QrCodeService(), permanent: true);
    print('   ✅ QrCodeService');

    Get.put(DocumentService(), permanent: true);
    print('   ✅ DocumentService');

    Get.put(ConfigurationService(), permanent: true);
    print('   ✅ ConfigurationService');
  }

  static void _initializeEssentialControllers() {
    print('🔧 Initialisation des controllers essentiels...');

    Get.put(AuthController(), permanent: true);
    print('   ✅ AuthController');

    Get.put(ThemeController(), permanent: true);
    print('   ✅ ThemeController');

    // Les autres controllers seront chargés via lazyPut
    // quand les pages correspondantes seront ouvertes
  }
}