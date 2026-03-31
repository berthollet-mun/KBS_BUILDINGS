// lib/app/middlewares/auth_middleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  // Routes accessibles sans connexion
  static const List<String> publicRoutes = [
    AppRoutes.splash,
    AppRoutes.welcome,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.biensDisponibles,
    AppRoutes.bienDetail,
    AppRoutes.visiteReserver,
    AppRoutes.qrCodeScan,
    AppRoutes.qrCodeResult,
  ];

  @override
  RouteSettings? redirect(String? route) {
    final storageService = Get.find<StorageService>();
    final isLoggedIn = storageService.isLoggedIn && storageService.hasToken;
    final currentRoute = route ?? '';

    debugPrint('🔒 AuthMiddleware: Route=$currentRoute, LoggedIn=$isLoggedIn');

    // 1. Si l'utilisateur n'est pas connecté et veut accéder à une route protégée
    if (!isLoggedIn && !publicRoutes.contains(currentRoute)) {
      debugPrint('   ↪ Redirection vers login');
      return const RouteSettings(name: AppRoutes.login);
    }

    // 2. Si l'utilisateur est connecté et essaie d'accéder au login/register
    if (isLoggedIn &&
        (currentRoute == AppRoutes.login ||
            currentRoute == AppRoutes.register)) {
      debugPrint('   ↪ Redirection vers dashboard');
      return const RouteSettings(name: AppRoutes.dashboard);
    }

    // 3. Accès autorisé
    return null;
  }
}